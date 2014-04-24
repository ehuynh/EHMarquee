//
//  EHMarqueeContainerView.h
//  EHMarquee
//
//  Created by Edward Huynh on 30/03/2014.
//
//

#import <UIKit/UIKit.h>

@interface EHMarqueeContainerView : UIView

/**
 label that we scrolled across the view
 */
@property (nonatomic, strong) UILabel *contentLabel;

/**
 duration for the label to scroll completely across the view
 */
@property (nonatomic) CGFloat scrollDuration;

@end
