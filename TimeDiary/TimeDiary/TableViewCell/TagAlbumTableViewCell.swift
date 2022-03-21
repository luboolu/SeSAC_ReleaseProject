//
//  TagAlbumTableViewCell.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/29.
//

import UIKit

final class TagAlbumTableViewCell: UITableViewCell {
    
    static let identifier = "TagAlbumTableViewCell"
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
