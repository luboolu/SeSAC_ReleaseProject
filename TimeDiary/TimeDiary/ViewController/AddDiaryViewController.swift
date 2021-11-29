//
//  AddDiaryViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/20.
//

import UIKit
import RealmSwift

class AddDiaryViewController: UIViewController {
    
    static let identifier = "AddDiaryViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var showTagPicker: UITextField!
    
    var selectedImage = UIImage()
    
    let localRealm = try! Realm()
    
    var tasks: Results<UserTag>!
    
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

        print(selectedImage.size.width, selectedImage.size.height)
        imageView.backgroundColor = .systemPink
        imageView.image = selectedImage
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String(NSLocalizedString("save", comment: "저장")), style: .plain, target: self, action: #selector(saveButtonClicked))
        
        
        contentTextView.text = "content"
        contentTextView.font = UIFont().kotra_songeulssi_13
        
    }
    
    @objc func saveButtonClicked() {
        print(#function)
        print(showTagPicker.text)
        //image, diary 저장
        var tag = "All"
        
        if showTagPicker.text! != "" {
            tag = showTagPicker.text!
        }
        
        //UserDiary에 데이터 추가
        let content = contentTextView.text
        let data = UserDiary(content: content, date: Date(), tag: tag)
        
        try! localRealm.write {
            localRealm.add(data)
        }
        print(tag)
        let tagData = localRealm.objects(UserTag.self).filter("tag == '\(tag)'").first!
        print(tagData)
        //UserTag 데이터 갱신
        try! localRealm.write {
            self.localRealm.create(UserTag.self, value: ["_id": tagData._id, "contentNum": tagData.contentNum + 1], update: .modified)
            
        }

        saveImageToDocumentDirectory(imageName: "\(data._id.stringValue).png", image: selectedImage)
        
        //Activity View Controller present
        let vc = UIActivityViewController(activityItems: [selectedImage], applicationActivities: [])
        vc.popoverPresentationController?.sourceView = self.view
        self.present(vc, animated: true, completion: nil)


    }
    
    @objc func dismissPicker() {
        print(#function)
        //self.view.endEditing(true)
        showTagPicker.resignFirstResponder()
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
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
