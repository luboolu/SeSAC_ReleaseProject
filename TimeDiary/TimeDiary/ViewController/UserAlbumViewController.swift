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
    
    
    @IBAction func cameraOpenButtonClicked(_ sender: UIButton) {
        print(#function)
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .camera
        
        
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func albumOpenButtonClicked(_ sender: UIButton) {
        print(#function)
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .photoLibrary


        self.present(self.imagePickerController, animated: true, completion: nil)
//        var configuration = PHPickerConfiguration()
//        configuration.selectionLimit = 1
//        configuration.filter = .any(of: [.images, .videos])
//        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = self
//        self.present(picker, animated: true, completion: nil)


        
    }
}

//사용자의 앨범에 접근하기 위한 imagePickerController 관련 extension
extension UserAlbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.imagePickerController.dismiss(animated: true) {
                //imagePickerView 닫으면서 imageEditViewController로 화면전환
                let st = UIStoryboard(name: "ImageEdit", bundle: nil)
                if let vc = st.instantiateViewController(withIdentifier: ImageEditViewController.identifer) as? ImageEditViewController {
                    
                    
                    vc.selectedImage = image
                    
                    vc.modalPresentationStyle = .fullScreen
                        
                    self.present(vc, animated: true, completion: nil)
                    
                    

                }
                

            }
            
        }
    }
    
}

extension UserAlbumViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                
                DispatchQueue.main.async {
                    //imagePickerView 닫으면서 imageEditViewController로 화면전환
                    let st = UIStoryboard(name: "ImageEdit", bundle: nil)
                    if let vc = st.instantiateViewController(withIdentifier: ImageEditViewController.identifer) as? ImageEditViewController {
                        
                        vc.selectedImage = image as! UIImage
                        vc.modalPresentationStyle = .fullScreen
                            
                        self.present(vc, animated: true, completion: nil)
                        
                    
                    }
                }
                

            }
        
        }
    }
    
    
}
