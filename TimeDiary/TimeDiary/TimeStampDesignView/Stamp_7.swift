//
//  Stamp_7.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/12/01.
//

import UIKit

class Stamp_7: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var contentLabel1: UILabel!
    
    //using customeView in code -> 사용중
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
        Bundle.main.loadNibNamed("Stamp_7", owner: self, options: nil)
        
        let date = Date()
        let timestamp1 = DateFormatter.timeFormat3_2.string(from: date)

        contentLabel1.text = "\(timestamp1)"
        contentLabel1.textColor = color
        contentLabel1.font = UIFont(name: "KOTRAHOPE", size: 80)
        
        
        //text field의 글자가 모두 보이는지 확인하고, 보이지 않는다면 글자의 크기를 조정하여 모두 보이게 함
        if contentLabel1.adjustsFontSizeToFitWidth == false {
            contentLabel1.adjustsFontSizeToFitWidth = true
        }
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }

}
