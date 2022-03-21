//
//  UIFont+Extension.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/22.
//

import UIKit

enum TimeBearFont: String {
    case KOTRA_SONGEULSSI = "KOTRA_SONGEULSSI"
    case KOTRA_LEAP = "KOTRALEAP"
    case KOTRA_HOPE = "KOTRAHOPE"
    case KYOBO_HANDWRITING_2019 = "Kyobo Handwriting 2019"
    case HEIR_OF_LIGHT_BOLD = "HeirofLightOTFBold"
    case ESAMARU_OTF_BOLD = "esamanru OTF Bold"
    case DUNGGEUNMO = "DungGeunMo"
    case JEJU_MYEONGJO_OTF = "JejuMyeongjoOTF"
}

extension UIFont {
    
    var kotra_songeulssi_13: UIFont {
        return UIFont(name: TimeBearFont.KOTRA_SONGEULSSI.rawValue, size: 13)!
    }
    
    var kotra_songeulssi_20: UIFont {
        return UIFont(name: TimeBearFont.KOTRA_SONGEULSSI.rawValue, size: 20)!
    }
    
    var kotra_songeulssi_30: UIFont {
        return UIFont(name: TimeBearFont.KOTRA_SONGEULSSI.rawValue, size: 30)!
    }
    
    var kotra_leap_30: UIFont {
        return UIFont(name: TimeBearFont.KOTRA_LEAP.rawValue, size: 30)!
    }
    
}
