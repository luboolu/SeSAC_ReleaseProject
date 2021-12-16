//
//  Stamp_12.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/12/01.
//

import UIKit

class Stamp_12: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var contentLabel1: UILabel!
    @IBOutlet weak var contentLabel2: UILabel!
    
    //using customeView in code
    init(frame: CGRect, color: UIColor, fontSize: CGFloat) {
        super.init(frame: frame)
        commonInit(color: color, fontSize: fontSize)
    }
    
    //using customView in XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(color: .white, fontSize: 0)
    }
    
    private func commonInit(color: UIColor, fontSize: CGFloat) {
        Bundle.main.loadNibNamed("Stamp_12", owner: self, options: nil)
        
        let date = Date()
        let timestamp1 = DateFormatter.dayFormat5.string(from: date)
        let timestamp2 = DateFormatter.timeFormat2_2.string(from: date)
        

        contentLabel1.text = "\(timestamp1)"
        contentLabel1.textColor = color
        contentLabel1.font = UIFont(name: "Kyobo Handwriting 2019", size: 30 + fontSize)
        
        contentLabel2.text = "\(timestamp2)"
        contentLabel2.textColor = color
        contentLabel2.font = UIFont(name: "Kyobo Handwriting 2019", size: 40 + fontSize)
        //text field의 글자가 모두 보이는지 확인하고, 보이지 않는다면 글자의 크기를 조정하여 모두 보이게 함
        if contentLabel1.adjustsFontSizeToFitWidth == false {
            contentLabel1.adjustsFontSizeToFitWidth = true
        }
        if contentLabel2.adjustsFontSizeToFitWidth == false {
            contentLabel2.adjustsFontSizeToFitWidth = true
        }
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
