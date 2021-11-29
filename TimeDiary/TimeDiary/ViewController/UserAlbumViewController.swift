//
//  UserAlbumViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/18.
//

import UIKit
import PhotosUI
import RealmSwift

class UserAlbumViewController: UIViewController  {
    
    let imagePickerController = UIImagePickerController()
    let localRealm = try! Realm()
    
  
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Realm 파일 위치
        print("Realm is loacaed at: ", localRealm.configuration.fileURL!)
        
        //UserTag 테이블에 데이터가 없으면 기본 데이터인 All을 추가
        let task = localRealm.objects(UserTag.self)
        
        if task.count == 0 {
            let data = UserTag(tag: "All", contentNum: 0)
            
            try! localRealm.write {
                localRealm.add(data)
            }

        }
        
//        timeDiaryTitleLabel.text = "Time Diary"
//        timeDiaryTitleLabel.font = UIFont().kotra_songeulssi_30
//        timeDiaryTitleLabel.textColor = .black
        
        cameraButton.setTitle(String(format: NSLocalizedString("camera", comment: "카메라로 타임스탬프 이미지 생성")), for: .normal)
        cameraButton.titleLabel?.font = UIFont().kotra_songeulssi_13
        //cameraButton.titleLabel?.textColor = .black
        //cameraButton.tintColor = .black
        cameraButton.backgroundColor = .clear
        

        //cameraButton.clipsToBounds = true
        //cameraButton.layer.cornerRadius = 10
        //cameraButton.layer.borderWidth = 1
        //cameraButton.layer.borderColor = UIColor.lightGray.cgColor
        
        albumButton.setTitle(String(format: NSLocalizedString("album", comment: "앨범으로 타임스탬프 이미지 생성")), for: .normal)
        albumButton.titleLabel?.font = UIFont().kotra_songeulssi_13
        //albumButton.titleLabel?.textColor = .black
        //albumButton.tintColor = .black
        albumButton.backgroundColor = .clear

//        albumButton.clipsToBounds = true
//        albumButton.layer.cornerRadius = 10
//        albumButton.layer.borderWidth = 1
//        albumButton.layer.borderColor = UIColor.lightGray.cgColor
//
        
        //tabbar setting
        tabBarController?.tabBar.selectedItem?.title = NSLocalizedString("image", comment: "이미지")

        tabBarController?.tabBar.tintColor = UIColor(named: "bear")
        


    }
    
    //카메라로 편집할 사진을 촬영
    @IBAction func cameraOpenButtonClicked(_ sender: UIButton) {
        print(#function)
        
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .camera
        
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    //사용자의 앨범에서 편집할 사진을 선택
    @IBAction func albumOpenButtonClicked(_ sender: UIButton) {
        print(#function)

        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images //어떤 종류의 media를 앨범에서 가져올지 설정
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)


        
    }
}

//사용자의 앨범에 접근하기 위한 imagePickerController 관련 extension
extension UserAlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.imagePickerController.dismiss(animated: true) {
                //imagePickerView 닫으면서 imageEditViewController로 화면전환
                let st = UIStoryboard(name: "ImageEdit", bundle: nil)
                if let vc = st.instantiateViewController(withIdentifier: ImageEditViewController.identifier) as? ImageEditViewController {
                    
                    vc.selectedImage = image
                    vc.modalPresentationStyle = .fullScreen
                        
                    //navigation bar를 포함하여 다음 뷰 컨트롤러로 화면전환 - push
                    self.navigationController?.pushViewController(vc, animated: true)
                    

                }

            }
            
        }
    }
    
}

extension UserAlbumViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true) {
            let itemProvider = results.first?.itemProvider
            
            if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    
                    if let image = object as? UIImage {
                        DispatchQueue.main.async {
                            //imagePickerView 닫으면서 imageEditViewController로 화면전환
                            let st = UIStoryboard(name: "ImageEdit", bundle: nil)
                            if let vc = st.instantiateViewController(withIdentifier: ImageEditViewController.identifier) as? ImageEditViewController {
                                
                                vc.selectedImage = image
                                vc.modalPresentationStyle = .fullScreen
                                    
                                //navigation bar를 포함하여 다음 뷰 컨트롤러로 화면전환 -  push
                                self.navigationController?.pushViewController(vc, animated: true)

                            }
                        }
                    }
                    

                    

                }
            
            }
        }
        

    }
    
    
}
