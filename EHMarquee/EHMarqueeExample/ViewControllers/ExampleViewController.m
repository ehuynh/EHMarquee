//
//  ExampleViewController.m
//  EHMarquee
//
//  Created by Edward Huynh on 30/03/2014.
//
//

#import "ExampleViewController.h"

#import <EHMarquee/EHMarqueeContainerView.h>

static NSString *shortText = @"Short amount of text.";
static NSString *longText = @"Looooong amount of text that needs scrolling.";

@interface ExampleViewController ()

@property (nonatomic, weak) UILabel *changingContentLabel;

@end

@implementation ExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSubviews];
}

- (void)addSubviews
{
    EHMarqueeContainerView *marqueeContainerView01 = [self createMarqueeContainerView];
    EHMarqueeContainerView *marqueeContainerView02 = [self createMarqueeContainerView];
    EHMarqueeContainerView *marqueeContainerView03 = [self createMarqueeContainerView];
    EHMarqueeContainerView *marqueeContainerView04 = [self createMarqueeContainerView];
    EHMarqueeContainerView *marqueeContainerView05 = [self createMarqueeContainerView];
    EHMarqueeContainerView *marqueeContainerView06 = [self createMarqueeContainerView];
    EHMarqueeContainerView *marqueeContainerView07 = [self createMarqueeContainerView];

    UIButton *changingLabelContentButton = [[UIButton alloc] init];
    [changingLabelContentButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    changingLabelContentButton.translatesAutoresizingMaskIntoConstraints = NO;
    [changingLabelContentButton setTitle:@"Change Text of above label" forState:UIControlStateNormal];
    [changingLabelContentButton addTarget:self action:@selector(changeLabelContent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:marqueeContainerView01];
    [self.view addSubview:marqueeContainerView02];
    [self.view addSubview:marqueeContainerView03];
    [self.view addSubview:marqueeContainerView04];
    [self.view addSubview:marqueeContainerView05];
    [self.view addSubview:marqueeContainerView06];
    [self.view addSubview:marqueeContainerView07];
    [self.view addSubview:changingLabelContentButton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(marqueeContainerView01,
                                                         marqueeContainerView02,
                                                         marqueeContainerView03,
                                                         marqueeContainerView04,
                                                         marqueeContainerView05,
                                                         marqueeContainerView06,
                                                         marqueeContainerView07,
                                                         changingLabelContentButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[marqueeContainerView01]-[marqueeContainerView02]-[marqueeContainerView03]-[marqueeContainerView04]-[marqueeContainerView05]-[marqueeContainerView06]-[marqueeContainerView07]-[changingLabelContentButton]"
                                                                      options:NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[marqueeContainerView01]-|"
                                                                      options:kNilOptions
                                                                      metrics:nil
                                                                        views:views]];
    
    UILabel *shortContentCenteredLabel = [[UILabel alloc] init];
    shortContentCenteredLabel.text = @"Short amount of text.";
    shortContentCenteredLabel.textAlignment = NSTextAlignmentCenter;
    marqueeContainerView01.contentLabel = shortContentCenteredLabel;
    
    UILabel *shortContentLeftAlignedLabel = [[UILabel alloc] init];
    shortContentLeftAlignedLabel.text = @"Short left aligned text.";
    shortContentLeftAlignedLabel.textAlignment = NSTextAlignmentLeft;
    marqueeContainerView02.contentLabel = shortContentLeftAlignedLabel;
    
    UILabel *longContentLabel = [[UILabel alloc] init];
    longContentLabel.text = @"Looooong amount of text that needs scrolling.";
    marqueeContainerView03.contentLabel = longContentLabel;
    
    UILabel *slowerContentLabel = [[UILabel alloc] init];
    slowerContentLabel.text = @"Slower looooong amount of text that needs scrolling.";
    marqueeContainerView04.contentLabel = slowerContentLabel;
    marqueeContainerView04.scrollDuration = 7.5f;
    
    UILabel *fasterContentLabel = [[UILabel alloc] init];
    fasterContentLabel.text = @"Faster looooong amount of text that needs scrolling.";
    marqueeContainerView05.contentLabel = fasterContentLabel;
    marqueeContainerView05.scrollDuration = 2.5f;
    
    UILabel *bigContentWithCustomFontLabel = [[UILabel alloc] init];
    bigContentWithCustomFontLabel.text = @"Bigger looooong amount of text that needs scrolling.";
    bigContentWithCustomFontLabel.font = [UIFont systemFontOfSize:24];
    marqueeContainerView06.contentLabel = bigContentWithCustomFontLabel;
    
    UILabel *changingContentLabel = [[UILabel alloc] init];
    changingContentLabel.text = shortText;
    marqueeContainerView07.contentLabel = changingContentLabel;
    self.changingContentLabel = changingContentLabel;
}

#pragma mark - EHMarqueeContainerView

- (EHMarqueeContainerView *)createMarqueeContainerView
{
    EHMarqueeContainerView *marqueeContainerView = [[EHMarqueeContainerView alloc] init];
    marqueeContainerView.backgroundColor = [UIColor lightGrayColor];
    marqueeContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    return marqueeContainerView;
}

#pragma mark - Target Action

- (void)changeLabelContent
{
    if ([self.changingContentLabel.text isEqualToString:shortText])
    {
        self.changingContentLabel.text = longText;
    }
    else
    {
        self.changingContentLabel.text = shortText;
    }
}

@end
