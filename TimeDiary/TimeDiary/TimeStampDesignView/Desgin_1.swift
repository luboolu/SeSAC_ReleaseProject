//
//  Desgin_1.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/24.
//

import UIKit

class Desgin_1: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
        //alternativeCustomInit() // 택 1
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
        //alternativeCustomInit() // 택 1
    }
    
    //방법 1. loadNibNamed
    func customInit() {
        if let view = Bundle.main.loadNibNamed("TimeStampDegin_1", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }
    }
    
    //방법 2. UINib 생성 후 instantiate
    func alternativeCustomInit() {
        if let view = UINib(nibName: "TimeStampDegin_1", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }
    }
}
