//
//  TimeStampDesign_2.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/25.
//
import UIKit


class Stamp_2 : UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var contentBorderView: UIView!
    @IBOutlet weak var contentLabel1: UILabel!
    
    //using customeView in code
    init(frame: CGRect, color: UIColor, fontName: String, fontSize: CGFloat) {
        super.init(frame: frame)
        commonInit(color: color, fontName: fontName, fontSize: fontSize)
    }
    
    //using customView in XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(color: .white, fontName: "HeirofLightOTFBold", fontSize: 0)
    }
    
    private func commonInit(color: UIColor, fontName: String, fontSize: CGFloat) {
        Bundle.main.loadNibNamed("Stamp_2", owner: self, options: nil)
        
        let date = Date()
        let timestamp1 = DateFormatter.timeFormat2_2.string(from: date)
        
        contentBorderView.layer.borderColor = color.cgColor
        contentBorderView.layer.borderWidth = 2
        
        contentLabel1.text = "\(timestamp1)"
        contentLabel1.textColor = color
        contentLabel1.font = UIFont(name: fontName, size: 30 + fontSize)
        //text field의 글자가 모두 보이는지 확인하고, 보이지 않는다면 글자의 크기를 조정하여 모두 보이게 함
        if contentLabel1.adjustsFontSizeToFitWidth == false {
            contentLabel1.adjustsFontSizeToFitWidth = true
        }
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
