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
    
    //let settingList = [["백업하기", "복구하기"], ["개인정보처리방침", "앱 버전"]]
    let settingList = [[NSLocalizedString("privacy", comment: "개인정보처리방침"), NSLocalizedString("openSourceLicense", comment: "오픈소스 라이센스") , NSLocalizedString("appVersion", comment: "앱 버전")]]
    

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
        //테이블뷰 선택 해제
        tableView.deselectRow(at: indexPath, animated: true)
        //테이블뷰 선택되면 화면전환
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            
            let st = UIStoryboard(name: "OpenSourceLicense", bundle: nil)
            if let vc = st.instantiateViewController(withIdentifier: OpenSourceLicenseViewController.identifier) as? OpenSourceLicenseViewController {
                
                
                vc.modalPresentationStyle = .fullScreen
                    
                //navigation bar를 포함하여 다음 뷰 컨트롤러로 화면전환 - push
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        } else if indexPath.row == 2 {
            let st = UIStoryboard(name: "UserAppVersion", bundle: nil)
            if let vc = st.instantiateViewController(withIdentifier: UserAppVersionViewController.identifier) as? UserAppVersionViewController {
                
                
                vc.modalPresentationStyle = .fullScreen
                    
                //navigation bar를 포함하여 다음 뷰 컨트롤러로 화면전환 - push
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            
        }
    }
    
    
}
