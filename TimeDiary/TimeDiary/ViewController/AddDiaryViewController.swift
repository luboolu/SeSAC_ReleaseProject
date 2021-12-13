//
//  AddDiaryViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/20.
//

import UIKit
import RealmSwift
import Toast
import Photos


class AddDiaryViewController: UIViewController {
    
    static let identifier = "AddDiaryViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var showTagTitle: UILabel!
    @IBOutlet weak var contentTitle: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var showTagPicker: UITextField!
    
    var tasks: Results<UserTag>!
    var selectedImage = UIImage()
    var selectedDate = Date()
    var style = ToastStyle()
    
    let localRealm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //UserTag Realm 접근
        tasks = localRealm.objects(UserTag.self)
        
        //pickerView setting
        showTagPicker.tintColor = .clear
        showTagPicker.placeholder = String(NSLocalizedString("selectTag", comment: "selectTag"))
        showTagPicker.font = UIFont().kotra_songeulssi_13
        
        createPickerView()
        dismissPickerView()

        //print(selectedImage.size.width, selectedImage.size.height)
        imageView.backgroundColor = .systemPink
        imageView.image = selectedImage
        
        showTagTitle.text = NSLocalizedString("folder", comment: "폴더")
        showTagTitle.font = UIFont().kotra_songeulssi_13
        
        contentTitle.text = NSLocalizedString("content", comment: "내용")
        contentTitle.font = UIFont().kotra_songeulssi_13
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String(NSLocalizedString("save", comment: "저장")), style: .plain, target: self, action: #selector(saveButtonClicked))
        
        
        contentTextView.text = ""
        contentTextView.font = UIFont().kotra_songeulssi_13
        contentTextView.clipsToBounds = true
        contentTextView.layer.cornerRadius = 10
        
        // this is just one of many style options
        self.style.messageColor = .white
        self.style.backgroundColor = .lightGray
        self.style.messageFont = UIFont().kotra_songeulssi_13
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @objc func saveButtonClicked() {
        print(#function)
        
        //일기 내용이 1000자 이상이면 저장되지 않도록
        let content = contentTextView.text!
        
        if content.count < 1000 {
            //print(showTagPicker.text)
            //image, diary 저장
            var tag = NSLocalizedString("notClassified", comment: "미분류")
            
            if showTagPicker.text! != "" {
                tag = showTagPicker.text!
            }
            
            //UserDiary에 데이터 추가
            let data = UserDiary(content: content, date: self.selectedDate, tag: tag)
            
            try! localRealm.write {
                localRealm.add(data)
            }
            //print(tag)
            let tagData = localRealm.objects(UserTag.self).filter("tag == '\(tag)'").first!
            //print(tagData)
            //UserTag 데이터 갱신
            try! localRealm.write {
                self.localRealm.create(UserTag.self, value: ["_id": tagData._id, "contentNum": tagData.contentNum + 1], update: .modified)
            }

            saveImageToDocumentDirectory(imageName: "\(data._id.stringValue).png", image: selectedImage)


            
            //Activity View Controller present
            let vc = UIActivityViewController(activityItems: [selectedImage], applicationActivities: [])

            vc.popoverPresentationController?.sourceView = self.view
            self.present(vc, animated: true, completion: nil)

            
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
        } else {
            self.view.makeToast(NSLocalizedString("longContent", comment: "길이 초과") ,duration: 2.0, position: .bottom, style: self.style)
        }
        
        



    }
    
    @objc func dismissPicker() {
        print(#function)
        //self.view.endEditing(true)
        showTagPicker.resignFirstResponder()
    }
    
    func createPickerView() {
        let pickerView = UIPickerView(frame: CGRect(x: 200, y: 0, width: UIScreen.main.bounds.width, height: 200))
        pickerView.delegate = self
        showTagPicker.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar(frame: showTagPicker.frame)
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: String(NSLocalizedString("select", comment: "pickerview select")), style: .plain, target: self, action: #selector(self.dismissPicker))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        showTagPicker.inputAccessoryView = toolBar

    }
    



    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        //1. 이미지를 저장할 경로 설정: document 폴더 -> FileManager 사용
        // Desktop/jack/ios/folder 도큐먼트 폴더의 경로는 계속 변하기 때문에 앙래와 같은 형태로 접근해야 한다.
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //document에 image 폴더 만들기
        let folderPath =  documentDirectory.appendingPathComponent("timediray_image")

        do {
            try FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
            

        } catch {
            print("Couldn't create document directory")
        }

        
        
        //2. 이미지 파일 이름
        //Desktop/jack/ios/folder/222.png
        let imageURL = folderPath.appendingPathComponent(imageName)
        
        //3. (선택) 이미지 압축 image.pngData()
        //guard let data = image.pngData() else { return }
        guard let data = image.jpegData(compressionQuality: 0.2) else { return }
        
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
        
        //5. 이미지를 도큐먼트에 저장
        do {
            try data.write(to: imageURL)
            print("이미지 저장 성공")
        } catch {
            print("이미지 저장 실패")
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

extension AddDiaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.tasks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.tasks[row].tag
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.showTagPicker.text = self.tasks[row].tag
    }
    
    
}
