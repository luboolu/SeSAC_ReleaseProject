import UIKit


let date = Date()
let formatter = DateFormatter()

formatter.dateFormat = "MMM dd HH mm"
formatter.locale = Locale(identifier: "en_KR")

print(formatter.string(from: date))
