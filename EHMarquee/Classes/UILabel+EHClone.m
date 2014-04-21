//
//  UILabel+EHClone.m
//  EHMarquee
//
//  Created by Edward Huynh on 21/04/2014.
//
//

#import "UILabel+EHClone.h"

@implementation UILabel (EHClone)

- (UILabel *)ehClone
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

@end
