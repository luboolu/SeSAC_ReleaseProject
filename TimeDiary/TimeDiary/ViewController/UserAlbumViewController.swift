//
//  UserAlbumViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/18.
//

import UIKit
import PhotosUI

class UserAlbumViewController: UIViewController  {
    
    let imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
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
