//
//  DesignCollectionViewCell.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/27.
//

import UIKit

class DesignCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DesignCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var designView: UIView!
    @IBOutlet weak var numLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
