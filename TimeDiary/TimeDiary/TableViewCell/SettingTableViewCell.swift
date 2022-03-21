//
//  SettingTableViewCell.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/22.
//

import UIKit

final class SettingTableViewCell: UITableViewCell {
    
    static let identifier = "SettingTableViewCell"
    
    @IBOutlet weak var settingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
