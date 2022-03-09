//
//  ViewController+Extension.swift
//  TimeDiary
//
//  Created by 김진영 on 2022/03/09.
//
import UIKit

import RxCocoa
import RxSwift
import RxKeyboard

extension UIViewController {

    func initializeKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
