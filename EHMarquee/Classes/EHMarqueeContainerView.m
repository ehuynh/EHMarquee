//
//  EHMarqueeContainerView.m
//  EHMarquee
//
//  Created by Edward Huynh on 30/03/2014.
//
//

#import "EHMarqueeContainerView.h"

#import "UILabel+EHClone.h"

static const CGFloat pointsPerSecond = 30.0f;
static const CGFloat labelSpacing = 40.0f;
static void * ContentLabelKVOContext = &ContentLabelKVOContext;

@interface EHMarqueeContainerView ()

@property (nonatomic, weak) NSLayoutConstraint *hContentLabelConstraint;
@property (nonatomic) CGFloat beginScrollDelay;
@property (nonatomic, strong) NSTimer *startScrollingTimer;
@property (nonatomic, weak) UILabel *contentLabelClone;

@end

@implementation EHMarqueeContainerView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    self.clipsToBounds = YES;
    self.scrollDuration = -1.0f;
    self.beginScrollDelay = 1.0f;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self shouldScroll] && !self.contentLabelClone)
    {
        [self addContentLabelClone];
        [self scheduleScrolling];
        [super layoutSubviews];
    }
}

#pragma makr - Content Label

- (void)setContentLabel:(UILabel *)contentLabel
{
    [self stopObservingContentLabel];
    [self removeContentLabelClone];
    
    [_contentLabel removeFromSuperview];
    _contentLabel = contentLabel;
    
    [self addContentLabel:contentLabel];
    [self observeContentLabel];
}

- (void)addContentLabel:(UILabel *)contentLabel
{
    contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:contentLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(contentLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentLabel]|"
                                                                 options:kNilOptions
                                                                 metrics:nil
                                                                   views:views]];
    
    NSLayoutConstraint *horizontalConstraintLeft = [NSLayoutConstraint constraintWithItem:contentLabel
                                                                                attribute:NSLayoutAttributeLeft
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self
                                                                                attribute:NSLayoutAttributeLeft
                                                                               multiplier:1.0f
                                                                                 constant:0.0f];

    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:contentLabel
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1.0f
                                                                        constant:0.0f];
    
    [self addConstraint:horizontalConstraintLeft];
    [self addConstraint:widthConstraint];
    self.hContentLabelConstraint = horizontalConstraintLeft;
}

#pragma mark - Content Label Clone

- (void)addContentLabelClone
{
    [self createContentLabelClone];
    [self addConstraintForContentLabelClone];
}

- (void)createContentLabelClone
{
    UILabel *contentLabelClone = [self.contentLabel eh_clone];
    [self addSubview:contentLabelClone];
    self.contentLabelClone = contentLabelClone;
}

- (void)addConstraintForContentLabelClone
{
    NSDictionary *views = @{@"contentLabel": self.contentLabel,
                            @"contentLabelClone": self.contentLabelClone};
    
    NSDictionary *metrics = @{@"labelSpacing": @(labelSpacing)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentLabel]-(labelSpacing)-[contentLabelClone]"
                                                                 options:NSLayoutFormatAlignAllTop|NSLayoutFormatAlignAllBottom
                                                                 metrics:metrics
                                                                   views:views]];
}

- (void)removeContentLabelClone
{
    [self.contentLabelClone removeFromSuperview];
    self.contentLabelClone = nil;
}

#pragma mark - Scrolling

- (void)rescheduleScrolling
{
    if ([self shouldScroll] && ![self.startScrollingTimer isValid])
    {
        [self scheduleScrolling];
    }
}

- (void)scheduleScrolling
{
    self.startScrollingTimer = [NSTimer scheduledTimerWithTimeInterval:self.beginScrollDelay
                                                                target:self
                                                              selector:@selector(scrollContentLabel)
                                                              userInfo:nil
                                                               repeats:NO];
}

- (void)scrollContentLabel
{
    CGFloat scrollDuration;
    
    if (self.scrollDuration > 0.0f)
    {
        scrollDuration = self.scrollDuration;
    }
    else
    {
        scrollDuration = (self.contentLabel.bounds.size.width + labelSpacing)/pointsPerSecond;
    }
    
    self.hContentLabelConstraint.constant = -self.contentLabel.bounds.size.width - labelSpacing;
    [UIView animateWithDuration:scrollDuration animations:^
     {
         [self layoutIfNeeded];
     }
                     completion:^(BOOL finished)
     {
         self.hContentLabelConstraint.constant = 0;
         
         [self rescheduleScrolling];
     }];
}

/**
 Cancels any inprogress scrolling animation and resets the ContentLabel position
 */
- (void)resetContentLabelToStartingPosition
{
    self.hContentLabelConstraint.constant = 0;
    
    // animate the change over 0.0f duration to cancel any inprogress animation
    [UIView animateWithDuration:0.0f animations:^
     {
         [self layoutIfNeeded];
     }
                     completion:nil];
}

- (BOOL)shouldScroll
{
    return self.contentLabel.bounds.size.width > self.bounds.size.width;
}

#pragma mark - KVO

- (void)observeContentLabel
{
    [self.contentLabel addObserver:self
                        forKeyPath:NSStringFromSelector(@selector(text)) 
                           options:NSKeyValueObservingOptionNew
                           context:ContentLabelKVOContext];
}

- (void)stopObservingContentLabel
{
    [self.contentLabel removeObserver:self
                           forKeyPath:NSStringFromSelector(@selector(text))
                              context:ContentLabelKVOContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(text))] && ContentLabelKVOContext)
    {
        [self contentLabelChanged];
    }
}

- (void)contentLabelChanged
{
    [self removeContentLabelClone];
    [self.startScrollingTimer invalidate];
    [self resetContentLabelToStartingPosition];
}

@end
