//
//  UserTagSelectViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/12/08.
//

import UIKit
import RealmSwift
import Toast

class UserTagSelectViewController: UIViewController {
    
    static let identifier = "UserTagSelectViewController"
    
    let localRealm = try! Realm()
    let DidDismissPostCommentViewController: Notification.Name = Notification.Name("DidDismissPostCommentViewController")
    
    var tasksTag: Results<UserTag>!
    var tasksDiary: Results<UserDiary>!
    var selectedData: [UserDiary] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tagTableView.delegate = self
        tagTableView.dataSource = self
        
        tasksTag = localRealm.objects(UserTag.self).sorted(byKeyPath: "_id", ascending: true)
        tasksDiary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "date", ascending: true)
        
        titleLabel.text = NSLocalizedString("selectFolder", comment: "이동할 폴더 선택")
        titleLabel.font = UIFont().kotra_songeulssi_20

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        super.viewWillDisappear(animated)
        //컬렉션뷰 선택되면 화면전환
        let vcs = self.navigationController?.viewControllers
        print(vcs)
        

        if let vc = presentedViewController as? UserTagAlbumViewController {
            //full screen으로 띄우니깐 되네..?근데 그렇다면 present-dismiss를 사용할 이유가..?읭??
            print("컬렉션뷰 갱신")
            vc.albumCollectionView.reloadData()
        }
//        if let firstVC = presentingViewController as? UserTagAlbumViewController {
//            DispatchQueue.main.async {
//                firstVC.albumCollectionView.reloadData()
//            }
//        }
        
        
//        if let vc = st.instantiateViewController(withIdentifier: UserTagAlbumViewController.identifier) as? UserTagAlbumViewController {
//
//            DispatchQueue.global().async {
//                DispatchQueue.main.sync {
//
//                    vc.albumCollectionView.reloadData()
//                }
//            }
//            //콜렉션뷰가 reload됐으면 좋겠는데 안된다..!!!어떻게 하지?
//        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override var prefersStatusBarHidden: Bool {
        return false
    }
    


}

extension UserTagSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksTag.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTagSelectTableViewCell.identifier, for: indexPath) as? UserTagSelectTableViewCell else {
            return UITableViewCell()
        }
        
        cell.tagLabel.text = tasksTag[indexPath.row].tag
        cell.tagLabel.font = UIFont().kotra_songeulssi_13
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        /*
         데이터 폴더 이동 코드 작성
         */
        let toTag = tasksTag[indexPath.row].tag
        let originalTag = selectedData[0].tag
        
        let totagData = localRealm.objects(UserTag.self).filter("tag == '\(toTag)'").first!
        let originalTagData = localRealm.objects(UserTag.self).filter("tag == '\(originalTag)'").first!
        
        
        for i in 0...selectedData.count - 1 {
            //tag 폴더 이동
            try! localRealm.write {
                self.localRealm.create(UserDiary.self, value: ["_id": selectedData[i]._id, "tag": toTag], update: .modified)
            }
            //새로 옮겨갈 UserTag의 contentNum + 1
            try! localRealm.write {
                self.localRealm.create(UserTag.self, value: ["_id": totagData._id, "contentNum": totagData.contentNum + 1], update: .modified)
            }
            
            //기존의 UserTag의 contentNum - 1
            try! localRealm.write {
                self.localRealm.create(UserTag.self, value: ["_id": originalTagData._id, "contentNum": originalTagData.contentNum - 1], update: .modified)
            }

        }
        self.view.makeToast(NSLocalizedString("moveComplete", comment: "폴더 변경 완료") ,duration: 1.0, position: .bottom, style: ToastStyle.defaultStyle)
        NotificationCenter.default.post(name: DidDismissPostCommentViewController, object: nil, userInfo: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
          // 1초 후 화면 전환
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
