//
//  UserTagSelectTableViewCell.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/12/08.
//

import UIKit

class UserTagSelectTableViewCell: UITableViewCell {
    
    static let identifier = "UserTagSelectTableViewCell"
    
    @IBOutlet weak var tagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
