//
//  DiaryTagTableViewCell.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/22.
//

import UIKit

final class DiaryTagTableViewCell: UITableViewCell {
    
    static let identifier = "DiaryTagTableViewCell"
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var contentNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
