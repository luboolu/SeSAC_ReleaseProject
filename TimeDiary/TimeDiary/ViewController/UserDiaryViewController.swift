//
//  UserDiaryViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/22.
//

import UIKit
import RealmSwift

class UserDiaryViewController: UIViewController {
    
    static let identifier = "UserDiaryViewController"
    
    let localRealm = try! Realm()
    
    var tasksTag: Results<UserTag>!
    var tasksDiary: Results<UserDiary>!
    
    @IBOutlet weak var diaryTagTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTagTableView.delegate = self
        diaryTagTableView.dataSource = self

        tasksTag = localRealm.objects(UserTag.self).sorted(byKeyPath: "_id", ascending: true)
        tasksDiary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "date", ascending: true)
        
        
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("my diary", comment: "일기장")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTagButtonClicked))
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        diaryTagTableView.reloadData()
    }

    @objc func addTagButtonClicked(_ sender: UIButton) {
        print(#function)
        //alert에 view(text field)를 추가하는 방식으로 tag 추가
        
        //1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
        //let alert = UIAlertController(title: "타이틀 테스트", message: "메시지가 입력되었습니다.", preferredStyle: .alert)
        let alert = UIAlertController(title: "폴더 추가", message: "추가할 폴더 이름을 입력해주세요", preferredStyle: .alert)
        
        //2. UIAlertAction 생성: 버튼들을...
        let ok = UIAlertAction(title: "추가", style: .default)
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        //3. 1 + 2
        alert.addAction(ok)
        alert.addAction(cancle)

        
        //4. present
        present(alert, animated: true, completion: nil)
        
//        let tagName = "new"
//
//        let task = UserTag(tag: tagName, contentNum: 0)
//
//        try! localRealm.write {
//            localRealm.add(task)
//            self.diaryTagTableView.reloadData()
//        }
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
    
    
}
