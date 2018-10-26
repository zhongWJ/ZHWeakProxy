//
//  ViewController.m
//  ZHWeakProxy
//
//  Created by zhong on 2018/10/26.
//  Copyright © 2018 zhong. All rights reserved.
//

#import "ViewController.h"
#import "ZHWeakProxy.h"

@interface ViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, assign) NSInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZHWeakProxy *weakProxy = [[ZHWeakProxy alloc] initWithObject:self];
    
    self.count = 0;
    self.timer = [NSTimer timerWithTimeInterval:0.5 target:weakProxy selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)timerTick:(NSTimer *)timer {
    self.count += 1;
    self.label.text = [NSString stringWithFormat:@"%ld", self.count];
}

- (void)dealloc {
    [self.timer invalidate];
}

@end
