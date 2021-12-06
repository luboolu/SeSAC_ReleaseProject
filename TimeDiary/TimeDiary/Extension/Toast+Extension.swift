//
//  Toast+Extension.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/12/06.
//

import Toast
import UIKit

var style = ToastStyle()

extension ToastStyle {
    
    static var defaultStyle: ToastStyle {
        
        // this is just one of many style options
        style.messageColor = .white
        style.backgroundColor = .lightGray
        style.messageFont = UIFont().kotra_songeulssi_13
        
        return style
    }
    
}
