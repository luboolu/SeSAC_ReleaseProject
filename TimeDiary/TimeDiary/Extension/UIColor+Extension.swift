//
//  UIColor+Extension.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/25.
//

import UIKit

enum TimeBearColor: String {
    case blue
    case green
    case yellow
    case orange
    case red
    case pink
    case purple
}

extension UIColor {
    
    var blue: UIColor {
        return UIColor(named: TimeBearColor.blue.rawValue)!
    }
    
    var green: UIColor {
        return UIColor(named: TimeBearColor.green.rawValue)!
    }
    
    var yellow: UIColor {
        return UIColor(named: TimeBearColor.yellow.rawValue)!
    }
    
    var orange: UIColor {
        return UIColor(named: TimeBearColor.orange.rawValue)!
    }
    
    var red: UIColor {
        return UIColor(named: TimeBearColor.red.rawValue)!
    }
    
    var pink: UIColor {
        return UIColor(named: TimeBearColor.pink.rawValue)!
    }
    
    var purple: UIColor {
        return UIColor(named: TimeBearColor.purple.rawValue)!
    }
    
}
