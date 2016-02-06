//
//  ANAUtils.m
//  Pods
//
//  Created by stonedong on 16/2/6.
//
//

#import "ANAUtils.h"
#import <MTA.h>
#import <objc/runtime.h>


@interface UIViewController (ANAUtils)

@end

@implementation UIViewController (ANAUtils)



- (void) __AddLogicViewWillAppear:(BOOL)animated
{
    [self __AddLogicViewWillAppear:animated];
}

- (void) __AddLogicViewDidAppear:(BOOL)animated
{
    [self __AddLogicViewDidAppear:animated];
    [MTA trackPageViewBegin:NSStringFromClass(self.class)];
}

- (void) __AddLogicViewWillDisappear:(BOOL)animated
{
    [self __AddLogicViewWillDisappear:animated];
 
}

- (void) __AddLogicViewDidDisappear:(BOOL)animated
{
    [self __AddLogicViewDidDisappear:animated];
    [MTA trackPageViewBegin:NSStringFromClass(self.class)];
 
}


@end




#pragma mark UILogicBootLoader

void DZSwizzingInstance(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod)
    {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@interface UILogicBootLoader : NSObject
@end
@implementation UILogicBootLoader
+ (void) load
{
    Class vcClass = [UIViewController class];
    DZSwizzingInstance(vcClass, @selector(viewWillAppear:), @selector(__AddLogicViewWillAppear:));
    DZSwizzingInstance(vcClass, @selector(viewDidAppear:), @selector(__AddLogicViewDidAppear:));
    DZSwizzingInstance(vcClass, @selector(viewWillDisappear:), @selector(__AddLogicViewWillDisappear:));
    DZSwizzingInstance(vcClass, @selector(viewDidDisappear:), @selector(__AddLogicViewDidDisappear:));
}
@end
