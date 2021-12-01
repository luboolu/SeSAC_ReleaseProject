//
//  UserTagAlbumDetailViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/29.
//

import UIKit
import RealmSwift
import Toast

class UserTagAlbumDetailViewController: UIViewController {
    
    static let identifier = "UserTagAlbumDetailViewController"
    
    let localRealm = try! Realm()
    
    var tasksDiary: UserDiary!
    var style = ToastStyle()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UITextView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let date = tasksDiary.date
        let timestamp1 = DateFormatter.yearDayFormat1.string(from: date)
        let timestamp2 = DateFormatter.timeFormat1.string(from: date)
        
        self.navigationItem.title = "\(timestamp1) \(timestamp2)"
        // Do any additional setup after loading the view.
       
        
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(removeButtonClicked))
        let editButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editButtonClicked))
        
        self.navigationItem.rightBarButtonItems = [trashButton, editButton]
        
        
        imageView.image = loadImageFromDocumentDirectory(imageName: "\(tasksDiary._id).png")
        
        contentView.isEditable = false
        contentView.text = tasksDiary.content
        contentView.font = UIFont().kotra_songeulssi_13
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        
        // this is just one of many style options
        self.style.messageColor = .white
        self.style.backgroundColor = .lightGray
        self.style.messageFont = UIFont().kotra_songeulssi_13
        
    }
    
    @objc func removeButtonClicked() {
        print(#function)
        
        let alert = UIAlertController(title: NSLocalizedString("alert", comment: "확인"), message: NSLocalizedString("deleteDiaryMessage", comment: "일기 삭제"), preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: "네"), style: .default) {
            (action) in
            
            //document에 저장된 이미지 삭제
            self.deleteImageFromDocumentDirectory(imageName: "\(self.tasksDiary._id).png")
            
            //UserTag contentNum 업데이트
            let tagData = self.localRealm.objects(UserTag.self).filter("tag == '\(self.tasksDiary.tag)'").first!
            
            //UserTag 데이터 갱신
            try! self.localRealm.write {
                self.localRealm.create(UserTag.self, value: ["_id": tagData._id, "contentNum": tagData.contentNum - 1], update: .modified)
            }
            
            try! self.localRealm.write {
                
                //UserDiary 데이터 삭제
                self.localRealm.delete(self.tasksDiary)
  
            }
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancle", comment: "취소"), style: .default, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        
        self.present(alert, animated: false, completion: nil)
    }
    
    @objc func editButtonClicked() {
        print(#function)
        
        contentView.isEditable = true
        
        let saveButton = UIBarButtonItem(title: NSLocalizedString("save", comment: "저장"), style: .plain, target: self, action: #selector(saveButtonClicked))

        
        self.navigationItem.rightBarButtonItems = [saveButton]
        self.navigationController?.navigationBar.tintColor = UIColor().red
        
    
        
        
    }
    
    @objc func saveButtonClicked() {
        print(#function)
        
        contentView.isEditable = false
        
        try! localRealm.write {
            self.localRealm.create(UserDiary.self, value: ["_id": self.tasksDiary._id, "content": contentView.text], update: .modified)
        }
        
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(removeButtonClicked))

        let editButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editButtonClicked))
        
        self.navigationItem.rightBarButtonItems = [trashButton, editButton]
        self.navigationController?.navigationBar.tintColor = UIColor(named: "bear")
        
        self.view.makeToast(NSLocalizedString("editSave", comment: "수정 내용 저장") ,duration: 2.0, position: .bottom, style: self.style)

    }
    
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        
        print(#function)
        
        let image = loadImageFromDocumentDirectory(imageName: "\(tasksDiary._id).png")

        //Activity View Controller present
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])

        vc.popoverPresentationController?.sourceView = self.view
        self.present(vc, animated: true, completion: nil)

        
        vc.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                self.view.makeToast(NSLocalizedString("imageSaveComplete", comment: "이미지 저장 완료") ,duration: 2.0, position: .bottom, style: self.style)
                
            } else {
                print("취소")
                
            }
            if let shareError = error {
                print(shareError)
                self.view.makeToast(NSLocalizedString("error", comment: "에러 발생") ,duration: 2.0, position: .bottom, style: self.style)
                
            }
            
        }
    }
    
    
    //도큐먼트 폴더 경로 -> 이미지 찾기 -> UIImage로 변환 -> UIImageView에 보여주기
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        //document에 image 폴더 만들기
        let folderPath =  documentDirectory.appendingPathComponent("timediray_image")
        

        let imageURL = URL(fileURLWithPath: folderPath.absoluteString).appendingPathComponent(imageName)
        
        if let image = UIImage(contentsOfFile: imageURL.path) {
            return image
        }
        
        return nil
    }
    
    func deleteImageFromDocumentDirectory(imageName: String) {
        //AddViewController의 saveButtonClicked와 같은 구조
        
        //1. 이미지를 저장할 경로 설정: document 폴더 -> FileManager 사용
        // Desktop/jack/ios/folder 도큐먼트 폴더의 경로는 계속 변하기 때문에 앙래와 같은 형태로 접근해야 한다.
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //document에 image 폴더
        let folderPath =  documentDirectory.appendingPathComponent("timediray_image")
        
        //2. 이미지 파일 이름
        //Desktop/jack/ios/folder/222.png
        let imageURL = folderPath.appendingPathComponent(imageName)
        
        
        //4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        //4-1. 이미지 경로 여부 확인 (이미 존재한다면 어떻게 할지)
        
        if FileManager.default.fileExists(atPath: imageURL.path) {
            
            //4-2. 기존 경로에 있는 이미지 삭제
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지 삭제 실패")
            }
        }
        
    }
    


}
