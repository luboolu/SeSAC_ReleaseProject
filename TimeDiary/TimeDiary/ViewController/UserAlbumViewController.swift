//
//  UserAlbumViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/18.
//

import UIKit
import PhotosUI
import RealmSwift
import Network
import AVFoundation
import Toast

final class UserAlbumViewController: UIViewController  {
    
    let imagePickerController = UIImagePickerController()
    let localRealm = try! Realm()
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRealmTask()
        setButton()
        setTabBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    private func setRealmTask() {
        //Realm 파일 위치
        print("Realm is loacaed at: ", localRealm.configuration.fileURL!)
        
        //UserTag 테이블에 데이터가 없으면 기본 tag 값인 '미분류' 추가
        let task = localRealm.objects(UserTag.self)
        
        if task.count == 0 {
            let notClassifiedData = UserTag(tag: NSLocalizedString("notClassified", comment: "미분류"), contentNum: 0)
            
            try! localRealm.write {
                //localRealm.add(allData)
                localRealm.add(notClassifiedData)
            }
        }
    }
    
    private func setButton() {
        cameraButton.setTitle(String(format: NSLocalizedString("camera", comment: "카메라로 타임스탬프 이미지 생성")), for: .normal)
        cameraButton.titleLabel?.font = UIFont().kotra_songeulssi_13
        cameraButton.backgroundColor = .clear
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = 0.5 * cameraButton.bounds.width
        cameraButton.layer.borderWidth = 0
        cameraButton.layer.borderColor = UIColor(named: "bear")?.cgColor
        
        albumButton.setTitle(String(format: NSLocalizedString("album", comment: "앨범으로 타임스탬프 이미지 생성")), for: .normal)
        albumButton.titleLabel?.font = UIFont().kotra_songeulssi_13
        albumButton.backgroundColor = .clear
        albumButton.clipsToBounds = true
        albumButton.layer.cornerRadius = 0.5 * albumButton.bounds.width
        albumButton.layer.borderWidth = 0
        albumButton.layer.borderColor = UIColor(named: "bear")?.cgColor
    }
    
    private func setTabBar() {
        //tabbar setting
        tabBarController?.tabBar.selectedItem?.title = NSLocalizedString("image", comment: "이미지")
        tabBarController?.tabBar.tintColor = UIColor(named: "bear")
    }

    //카메라로 편집할 사진을 촬영
    @IBAction func cameraOpenButtonClicked(_ sender: UIButton) {
        print(#function)
        
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .camera
        
        //NSCameraUsageDescription 권한에 대한 요청
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                DispatchQueue.global().async {
                    // UI 업데이트 전 실행되는 코드
                    DispatchQueue.main.sync {
                        self.present(self.imagePickerController, animated: true, completion: nil)
                    }
                }
            } else {
                DispatchQueue.global().async {
                    // UI 업데이트 전 실행되는 코드
                    DispatchQueue.main.sync {
                        self.settingAlert()
                    }
                }
            }
        })
        

    }
    
    //사용자의 앨범에서 편집할 사진을 선택 - PHPickerViewController 사용
    @IBAction func albumOpenButtonClicked(_ sender: UIButton) {
        print(#function)

        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images //어떤 종류의 media를 앨범에서 가져올지 설정 - 타임베어에서는 이미지만 가져오도록 함
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    //권한이 설정되지 않았을때, 권한 설정을 유도하는 alert 띄우기(설정 앱으로 이동시켜줌)
    private func settingAlert() {
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

//imagePickerController 관련 extension - 앱 내에서 카메라로 촬영한 사진에 대해서
extension UserAlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //imagePicker에서 촬영된 이미지가 선택됐을때 실행됨
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePickerController.dismiss(animated: true) {
                //imagePickerView를 닫고 imageEditViewController로 화면전환 + 이미지 전달
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

//PHPicker로 사용자의 앨범에서 사진을 선택하는 것 관련한 extension - album
extension UserAlbumViewController: PHPickerViewControllerDelegate {
    //앨범에서 사진이 선택됐을때 실행됨
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        //picker를 닫으면서 화면전환 + 이미지 전달
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
                    
                    if error != nil {
                        //사진 로딩 과정에서 에러가 발생했다면 alert를 띄우거나 toast를 띄우는 것이...!
                        DispatchQueue.global().async {
                            // UI 업데이트 전 실행되는 코드
                            DispatchQueue.main.sync {
                                self.view.makeToast(NSLocalizedString("imageLoadingError", comment: "이미지 로딩 에러") ,duration: 2.0, position: .bottom, style: ToastStyle.defaultStyle)
                            }
                        }
                        
                    }
                }
            
            }
        }
        

    }
    
    
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

