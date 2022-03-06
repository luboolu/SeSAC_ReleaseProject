//
//  OpenSourceLicenseViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/12/01.
//

import UIKit
import WebKit

class OpenSourceLicenseViewController: UIViewController {
    
    static let identifier = "OpenSourceLicenseViewController"
    
    @IBOutlet weak var webView: WKWebView!
    
    let str = """
        <!DOCTYPE html>
            <html>
            <head>
              <meta charset='utf-8'>
              <meta name='viewport' content='width=device-width'>
              <title>Open Source</title>
              <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
            </head>
            <body>
            <strong>Realm</strong><p>https://github.com/realm/realm-cocoa</p>
            <strong>IQKeyboardManager</strong><p>https://github.com/hackiftekhar/IQKeyboardManager</p>
            <strong>Toast</strong><p>https://github.com/scalessec/Toast-Swift</p>
            <strong>JGProgressHUD</strong><p>https://github.com/JonasGessner/JGProgressHUD.git</p>
                        
            </body>
            </html>

        """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(NSLocalizedString("openSourceLicense", comment: "오픈소스 라이센스"))"
        
        self.webView.loadHTMLString(str, baseURL: nil)

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override var prefersStatusBarHidden: Bool {
        return false
    }

}
