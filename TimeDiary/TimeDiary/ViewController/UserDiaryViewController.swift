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
    
    var tasks: Results<UserTag>!
    
    @IBOutlet weak var diaryLabel: UILabel!
    @IBOutlet weak var diaryTagTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryTagTableView.delegate = self
        diaryTagTableView.dataSource = self

        tasks = localRealm.objects(UserTag.self).sorted(byKeyPath: "tag", ascending: false)
        
        diaryLabel.text = "My Diary"
        
    }

    @IBAction func addTagButtonClicked(_ sender: UIButton) {
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
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryTagTableViewCell.identifier, for: indexPath) as? DiaryTagTableViewCell else {
            return UITableViewCell()
        }
        
        let row = tasks[indexPath.row]
        
        cell.tagLabel.text = row.tag
        cell.contentNumLabel.text = "\(row.contentNum)"
        
        return cell
        
    }
    
    
}
