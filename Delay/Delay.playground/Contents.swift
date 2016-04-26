
import Foundation

func delay(delay:Double, closure:()->()) {
  dispatch_after(
    dispatch_time(
      DISPATCH_TIME_NOW,
      Int64(delay * Double(NSEC_PER_SEC))
    ),
    dispatch_get_main_queue(), closure)
}

print("Date before delay: \(NSDate())")
delay(0.3) {
  print("Date after delay: \(NSDate())")
}
