//
//  UserDiaryViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/22.
//

import UIKit
import RealmSwift
import CloudKit
import Toast

class UserDiaryViewController: UIViewController {
    
    static let identifier = "UserDiaryViewController"
    
    let localRealm = try! Realm()
    
    var tasksTag: Results<UserTag>!
    var tasksDiary: Results<UserDiary>!
    var style = ToastStyle()
    
    @IBOutlet weak var diaryTagTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTagTableView.delegate = self
        diaryTagTableView.dataSource = self

        tasksTag = localRealm.objects(UserTag.self).sorted(byKeyPath: "_id", ascending: true)
        tasksDiary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "date", ascending: true)
        
        
        //navigationbar setting
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("my diary", comment: "일기장")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTagButtonClicked))
        
        //tabbar setting
        tabBarController?.tabBar.selectedItem?.title = NSLocalizedString("diary", comment: "일기")

        tabBarController?.tabBar.tintColor = UIColor(named: "bear")
        
        // this is just one of many style options
        self.style.messageColor = .white
        self.style.backgroundColor = .lightGray
        self.style.messageFont = UIFont().kotra_songeulssi_13
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        diaryTagTableView.reloadData()
    }

    @objc func addTagButtonClicked(_ sender: UIButton) {
        print(#function)
        //alert에 view(text field)를 추가하는 방식으로 tag 추가
        
        //1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
        //let alert = UIAlertController(title: "타이틀 테스트", message: "메시지가 입력되었습니다.", preferredStyle: .alert)
        let alert = UIAlertController(title: NSLocalizedString("addFolderTitle", comment: "폴더 추가"), message: NSLocalizedString("addFolderMessage", comment: "폴더 추가"), preferredStyle: .alert)

        alert.addTextField { tagTextField in
            
            tagTextField.placeholder = NSLocalizedString("folderName", comment: "폴더 이름")
            //tagTextField.frame = sender.frame

        }
        //2. UIAlertAction 생성: 버튼들을...
        let ok = UIAlertAction(title: NSLocalizedString("add", comment: "추가"), style: .default) { ok in
            //ok 버튼이 눌리면 textField에 입력된 값을 UserTag에 추가
            if let tag = alert.textFields?[0].text {
                //1.UserTag에 존재하지 않는 값이 입력된 경우 - 성공
                let searchTag = self.localRealm.objects(UserTag.self).filter("tag = '\(tag)'")
                
                if searchTag.count == 0 {
                    //성공
                    let data = UserTag(tag: tag, contentNum: 0)
                    
                    try! self.localRealm.write {
                        self.localRealm.add(data)
                        self.diaryTagTableView.reloadData()
                    }
                } else {
                    //실패 - 중복 존재
                    // present the toast with the new style
                    self.view.makeToast(NSLocalizedString("addFolderFailToast", comment: "폴더 생성 실패") ,duration: 2.0, position: .bottom, style: self.style)
                }
                //2.UserTag에 존재하는 값이 입력된 경우 - 실패
                
                //2-1. "" 공백값이 입력된 경우 - 실패
            } else {
                // present the toast with the new style
                self.view.makeToast(NSLocalizedString("addFolderFailToast", comment: "폴더 생성 실패") ,duration: 2.0, position: .bottom, style: self.style)
            }

        }
        
        let cancle = UIAlertAction(title: NSLocalizedString("cancle", comment: "취소"), style: .cancel) { cancle in

            // present the toast with the new style
            self.view.makeToast(NSLocalizedString("addFolderCancleToast", comment: "폴더 생성 취소") ,duration: 2.0, position: .bottom, style: self.style)

        }
        //3. 1 + 2
        alert.addAction(ok)
        alert.addAction(cancle)


        //4. present
        present(alert, animated: true, completion: nil)
        
    }
}

extension UserDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksTag.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTagTableViewCell.identifier, for: indexPath) as? DiaryTagTableViewCell else {
            return UITableViewCell()
        }
        
        let row = tasksTag[indexPath.row]
        
        cell.tagLabel.text = row.tag
        cell.tagLabel.font = UIFont().kotra_songeulssi_13
        
        if indexPath.row != 0 {
            cell.contentNumLabel.text = "\(row.contentNum)"
            cell.contentNumLabel.font = UIFont().kotra_songeulssi_13
        } else {
            cell.contentNumLabel.text = ""
        }

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        //테이블뷰 선택되면 화면전환
        let st = UIStoryboard(name: "UserTagAlbum", bundle: nil)
        if let vc = st.instantiateViewController(withIdentifier: UserTagAlbumViewController.identifier) as? UserTagAlbumViewController {
            
            
            vc.tagData = self.tasksTag[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
                
            //navigation bar를 포함하여 다음 뷰 컨트롤러로 화면전환 - push
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //일단 스와이프 자체를 비활성화 시켜둠
        return false
    }
    
    //오른쪽 스와이프 - 폴더 삭제 기능
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            
            let alert = UIAlertController(title: NSLocalizedString("alert", comment: "폴더 삭제 확인"), message: NSLocalizedString("deleteFolderMessage", comment: "폴더 삭제 확인"), preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: "네"), style: .default) {
                (action) in
                
                try! self.localRealm.write {
                    
                    self.localRealm.delete(self.tasksTag[indexPath.row])
                    
                    //self.localRealm.delete(self.tasksDiary.filter())
                    
                    tableView.reloadData()
                }
                
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("cancle", comment: "취소"), style: .default, handler: nil)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: false, completion: nil)

            success(true)
        }
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = UIColor(named: "MemoRed")
        
        return UISwipeActionsConfiguration(actions:[delete])
    }
    
    
}
