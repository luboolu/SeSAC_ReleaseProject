//
//  TimeStampDesign_1.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/25.
//

import UIKit


class Stamp_1 : UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var contentLabel1: UILabel!
    
    //using customeView in code
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        commonInit(color: color)
    }
    
    //using customView in XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(color: .white)
    }
    
    private func commonInit(color: UIColor) {
        Bundle.main.loadNibNamed("Stamp_1", owner: self, options: nil)
        
        contentLabel1.text = "21.11.25"
        contentLabel1.textColor = color
        contentLabel1.font = UIFont().kotra_leap_30
        //text field의 글자가 모두 보이는지 확인하고, 보이지 않는다면 글자의 크기를 조정하여 모두 보이게 함
        if contentLabel1.adjustsFontSizeToFitWidth == false {
            contentLabel1.adjustsFontSizeToFitWidth = true
        }
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
