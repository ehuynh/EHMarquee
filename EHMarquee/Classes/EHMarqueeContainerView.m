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

@interface EHMarqueeContainerView ()

@property (nonatomic, weak) NSLayoutConstraint *hContentLabelConstraint;
@property (nonatomic) CGFloat beginScrollDelay;
@property (nonatomic, strong) NSTimer *startScrollingTimer;
@property (nonatomic, strong) UILabel *contentLabelClone;

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
    _contentLabel = contentLabel;
    
    [self addContentLabel:contentLabel];
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
    UILabel *contentLabelClone = [self.contentLabel ehClone];
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

#pragma mark - Scrolling

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
         [self scheduleScrolling];
     }];
}

- (BOOL)shouldScroll
{
    return self.contentLabel.bounds.size.width > self.bounds.size.width;
}

@end
