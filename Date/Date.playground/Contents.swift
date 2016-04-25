
import Foundation

var date = NSDate()
print(date.description)
print(date.timeIntervalSince1970)

let dateFormatter = NSDateFormatter()
let dateString = "2016-05-01 00:00:00"
dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
print(dateFormatter.dateFromString(dateString))
