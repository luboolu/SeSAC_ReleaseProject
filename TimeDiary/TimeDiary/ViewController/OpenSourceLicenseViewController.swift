//
//  OpenSourceLicenseViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/12/01.
//

import UIKit

class OpenSourceLicenseViewController: UIViewController {
    
    static let identifier = "OpenSourceLicenseViewController"

    
    @IBOutlet weak var licenseTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(NSLocalizedString("opensourceLicense", comment: "오픈소스 라이센스"))"
        
        licenseTextView.isEditable = false
        licenseTextView.text = "<Realm>\n https://github.com/realm/realm-cocoa \n\n <IQKeyboardManager>\n https://github.com/hackiftekhar/IQKeyboardManager \n\n <Toast>\n https://github.com/scalessec/Toast-Swift "
        licenseTextView.font = UIFont().kotra_songeulssi_13

        // Do any additional setup after loading the view.
    }
    

    
}
