//
//  UIView + RNSComponent.m
//  ReusableNestingScrollview
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "UIView + RNSComponent.h"
#import <objc/runtime.h>

@implementation UIView (RNSComponent)
- (void)setRNSId:(NSString *)RNSId{
    objc_setAssociatedObject(self, @"RNSId", RNSId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)RNSId{
    NSString *RNSId = objc_getAssociatedObject(self, @"RNSId");
    return RNSId;
}
@end
