//
//  TimeStampDesign_1.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/25.
//

import UIKit


class TimeStampDesign_1 : UIView {
    
    @IBOutlet var contentView: TimeStampDesign_1!
    @IBOutlet weak var contentLabel1: UILabel!
    
    //using customeView in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    //using customView in XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TimeStampDesign_1", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
