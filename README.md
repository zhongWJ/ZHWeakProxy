# ZHWeakProxy

A weak proxy object. ZHWeakProxy will forwarding message to weakObject, but not keep a strong reference to weakObject.

When use NSTimer, we will face a retain cycle problem. Because NSTimer keep a strong reference to self, and self keep a strong reference to NSTimer, dealloc won't be called.

```
//retain cycle
self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

- (void)dealloc {
    [self.timer invalidate];
}
```

By use weakProxy, the retain cycle is broken.
```
self ---strong---> timer ---strong---> weakProxy
^                                          |
--------------------weak--------------------
```
```
ZHWeakProxy *weakProxy = [[ZHWeakProxy alloc] initWithObject:self];
self.timer = [NSTimer timerWithTimeInterval:0.5 target:weakProxy selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

- (void)dealloc {
    [self.timer invalidate];
}
```