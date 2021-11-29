//
//  UserTagAlbumViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/29.
//

import UIKit

class UserTagAlbumViewController: UIViewController {
    
    static let identifier = "UserTagAlbumViewController"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}

extension UserTagAlbumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    
}
