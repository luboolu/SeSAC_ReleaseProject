//
//  UserSettingViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/22.
//

import UIKit

class UserSettingViewController: UIViewController {
    
    static let identifier = "UserSettingViewController"
    
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    
    let settingList = [["백업하기", "복구하기"], ["개인정보처리방침", "앱 버전"]]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("setting", comment: "설정")
        
        //tabbar setting
        tabBarController?.tabBar.selectedItem?.title = NSLocalizedString("setting", comment: "설정")

        tabBarController?.tabBar.tintColor = UIColor(named: "bear")
    }

}

extension UserSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.settingLabel.text = settingList[indexPath.section][indexPath.row]
        cell.settingLabel.font = UIFont().kotra_songeulssi_13
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
