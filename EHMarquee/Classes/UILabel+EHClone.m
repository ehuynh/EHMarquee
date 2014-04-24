//
//  UILabel+EHClone.m
//  EHMarquee
//
//  Created by Edward Huynh on 21/04/2014.
//
//

#import "UILabel+EHClone.h"

@implementation UILabel (EHClone)

- (UILabel *)eh_clone
{
    // turns out a quick way to create a clone is to just archive and unarchive the receiver
    // See http://stackoverflow.com/a/13756101/666943
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

@end
