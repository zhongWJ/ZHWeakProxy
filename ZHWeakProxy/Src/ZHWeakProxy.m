//
//  ZHWeakProxy.m
//  ZHWeakProxy
//
//  Created by zhong on 2018/10/26.
//  Copyright © 2018 zhong. All rights reserved.
//

#import "ZHWeakProxy.h"

@interface ZHWeakProxy ()

@property (nonatomic, weak) id weakObject;

@end

@implementation ZHWeakProxy

- (instancetype)initWithObject:(NSObject *)object {
    self = [super init];
    if (self) {
        self.weakObject = object;
    }
    return self;
}

#pragma mark -

//Fast forwarding
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.weakObject;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation setTarget:self.weakObject];
    [anInvocation invoke];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    __strong id strongObject = self.weakObject;
    if (strongObject) {
        return [strongObject methodSignatureForSelector:aSelector];
    } else {
#if DEBUG == 1
        //if return nil methodsignature, it will crash.
        //this will force you to release proxy object
        //before weakObject dealloc
        return nil;
#else
        NSString *idSignature = [NSString stringWithUTF8String:@encode(id)];
        NSString *selSignature = [NSString stringWithUTF8String:@encode(SEL)];
        NSString *types = [NSString stringWithFormat:@"%@%@", idSignature, selSignature];
        NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:types.UTF8String];
        return methodSignature;
#endif
    }
}

@end
