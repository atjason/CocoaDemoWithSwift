# dispatch_after

```swift
func delay(delay:Double, closure:()->()) {    dispatch_after(        dispatch_time(            DISPATCH_TIME_NOW,            Int64(delay * Double(NSEC_PER_SEC))        ),        dispatch_get_main_queue(), closure)}
```

Usage:

```swift
delay(0.4) {    // do stuff}
```

