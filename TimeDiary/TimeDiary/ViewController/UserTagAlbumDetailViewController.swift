//
//  UserTagAlbumDetailViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/29.
//

import UIKit
import RealmSwift
import Toast
import Photos
import JGProgressHUD

final class UserTagAlbumDetailViewController: UIViewController {
    
    static let identifier = "UserTagAlbumDetailViewController"
    
    private let localRealm = try! Realm()
    
    var tasksDiary: UserDiary!
    var style = ToastStyle()
    var editMode = false

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var textLengthLabel: UILabel!
    @IBOutlet weak var contentStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        setNavigationBar()
        setView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.editMode = false
        self.contentView.isEditable = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    private func setView() {
        imageView.image = loadImageFromDocumentDirectory(imageName: "\(tasksDiary._id).png")
        
        contentView.isEditable = false
        contentView.text = tasksDiary.content
        contentView.font = UIFont().kotra_songeulssi_13
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        
        //textview didchange 사용위해서 delegate 연결
        contentView.delegate = self
        
        textLengthLabel.isHidden = true //처음엔 hidden
        textLengthLabel.text = "\(contentView.text.count)/1000"
        textLengthLabel.font = UIFont().kotra_songeulssi_13
        textLengthLabel.textColor = UIColor(named: "bear")
    }
    
    private func setNavigationBar() {
        let date = tasksDiary.date
        let timestamp1 = DateFormatter.yearDayFormat1.string(from: date)
        let timestamp2 = DateFormatter.timeFormat3_2.string(from: date)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "\(timestamp1) \(timestamp2)"
        
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(removeButtonClicked))
        let editButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editButtonClicked))
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
        
        self.navigationItem.rightBarButtonItems = [trashButton, editButton]
        self.navigationItem.leftBarButtonItem = backButton
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
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        
        self.present(alert, animated: false, completion: nil)
    }
    
    @objc func editButtonClicked() {
        print(#function)
        
        editMode = true
        contentView.isEditable = true
        textLengthLabel.isHidden = false
        
        let saveButton = UIBarButtonItem(title: NSLocalizedString("save", comment: "저장"), style: .plain, target: self, action: #selector(saveButtonClicked))

        self.navigationItem.rightBarButtonItems = [saveButton]
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "bear")

        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont().kotra_songeulssi_20]
    }
    
    @objc func saveButtonClicked() {
        print(#function)
        //일기 내용이 1000자 이상이면 저장되지 않도록
        let content = contentView.text!
        
        if content.count <= 1000 {
            editMode = false
            contentView.isEditable = false
            textLengthLabel.isHidden = true
            
            try! localRealm.write {
                self.localRealm.create(UserDiary.self, value: ["_id": self.tasksDiary._id, "content": contentView.text], update: .modified)
            }
            
            let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(removeButtonClicked))

            let editButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editButtonClicked))
            
            self.navigationItem.rightBarButtonItems = [trashButton, editButton]
            self.navigationController?.navigationBar.backgroundColor = .clear
            self.navigationController?.navigationBar.tintColor = UIColor(named: "bear")
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont().kotra_songeulssi_20]
            
            self.view.makeToast(NSLocalizedString("editSave", comment: "수정 내용 저장") ,duration: 2.0, position: .bottom, style: .defaultStyle)
            
        } else {
            self.view.makeToast(NSLocalizedString("longContent", comment: "길이 초과") ,duration: 2.0, position: .bottom, style: .defaultStyle)
        }

    }
    
    @objc func backButtonClicked() {
        print(#function)
        if editMode {
            //1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
            //let alert = UIAlertController(title: "타이틀 테스트", message: "메시지가 입력되었습니다.", preferredStyle: .alert)
            let alert = UIAlertController(title: NSLocalizedString("needSaveTitle", comment: "저장필요"), message: NSLocalizedString("needSaveMessage", comment: "저장필요"), preferredStyle: .alert)
            
            //2. UIAlertAction 생성: 버튼들을...
            let ok = UIAlertAction(title: NSLocalizedString("alert", comment: "ok"), style: .default)

            //3. 1 + 2
            alert.addAction(ok)
            
            //4. present
            present(alert, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        print(#function)
        
        let requiredAccessLevel: PHAccessLevel = .addOnly
        
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { (status) in
            print("***** Status: \(status)")
            switch status {
            case .limited:
                print("limited authorization granted")
            case .authorized:
                print("authorization granted")
            case .denied:
                DispatchQueue.global().async {
                    // UI 업데이트 전 실행되는 코드
                    DispatchQueue.main.sync {
                        //self.dismiss(animated: true, completion: nil)
                        self.settingAlert()
                    }
                }
            default: //FIXME: Implement handling for all authorizationStatus
                print("Unimplemented")

            }
        }
        
        let image = loadImageFromDocumentDirectory(imageName: "\(tasksDiary._id).png")

        //Activity View Controller present
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])

        vc.popoverPresentationController?.sourceView = self.view
        self.present(vc, animated: true, completion: nil)
        
        //이미지 저장에 보여줄 hud 정의
        let savingHud = JGProgressHUD()
        savingHud.vibrancyEnabled = true
        savingHud.style = .dark
        savingHud.textLabel.text = NSLocalizedString("imageSaving", comment: "이미지 저장중")
        savingHud.detailTextLabel.text = nil


        vc.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                savingHud.show(in: self.view)
                savingHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                savingHud.textLabel.text = NSLocalizedString("imageSaveComplete", comment: "이미지 저장 완료")
                savingHud.dismiss(afterDelay: 1.5, animated: true)
                
            } else {
                print("취소")
                
            }
            if let shareError = error {
                print(shareError)
                self.view.makeToast(NSLocalizedString("error", comment: "에러 발생") ,duration: 2.0, position: .bottom, style: .defaultStyle)
                
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
    
    func settingAlert() {
        print(#function)
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let alert = UIAlertController(title: NSLocalizedString("setting", comment: "설정"), message: "\(appName)\(NSLocalizedString("accessSetting", comment: "설정화면 안내"))", preferredStyle: .alert)
            let cancleAction = UIAlertAction(title: NSLocalizedString("cancle", comment: "취소"), style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            }
            let confirmAction = UIAlertAction(title: NSLocalizedString("ok", comment: "확인"), style: .default) { action in
                
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            
            alert.addAction(cancleAction)
            alert.addAction(confirmAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension UserTagAlbumDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let count = textView.text.count ?? 0
        
        if count <= 1000 {
            DispatchQueue.main.async {
                self.textLengthLabel.textColor = UIColor(named: "bear")
            }
        } else {
            DispatchQueue.main.async {
                self.textLengthLabel.textColor = UIColor().red
            }
        }
        
        DispatchQueue.main.async {
            self.textLengthLabel.text = "\(textView.text.count ?? 0)/1000"
        }
    }
}
