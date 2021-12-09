//
//  TagAlbumCollectionViewCell.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/29.
//

import UIKit

class TagAlbumCollectionViewCell: UICollectionViewCell {

    static let identifier = "TagAlbumCollectionViewCell"
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var selectedButton: UIImageView!
    @IBOutlet weak var selectEffect: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
