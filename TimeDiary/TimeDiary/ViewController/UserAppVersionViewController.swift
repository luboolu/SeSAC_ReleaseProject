//
//  UserAppVersionViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/12/01.
//

import UIKit

final class UserAppVersionViewController: UIViewController {
    
    static let identifier = "UserAppVersionViewController"
    
    @IBOutlet weak var nowAppVersionLabel: UILabel!
    @IBOutlet weak var latestAppVersionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(NSLocalizedString("appVersion", comment: "앱 버전"))"
        
        versionCompare()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    private func versionCompare() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        if let version = version{
            print("version: \(version)")
            nowAppVersionLabel.text = "\(version)"
            nowAppVersionLabel.font = UIFont().kotra_songeulssi_13
        }
        
        if isUpdateAvailable() {
            latestAppVersionLabel.text = NSLocalizedString("needUpdate", comment: "업데이트 필요")
        } else {
            latestAppVersionLabel.text = NSLocalizedString("notNeedUpdate", comment: "최신버전")
        }
        latestAppVersionLabel.font = UIFont().kotra_songeulssi_13
    }
    
    private func isUpdateAvailable() -> Bool {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.jy.TimeBear"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let appStoreVersion = results[0]["version"] as? String else {
                print("guard out")
                return false
            }
        print(appStoreVersion)
        if !(version == appStoreVersion) {
            return true
            
        } else {
            return false
            
        }

    }

}
