//
//  ImageEditViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/18.
//

import UIKit

class ImageEditViewController: UIViewController {

    static let identifer = "ImageEditViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var colorButton1: UIButton!
    @IBOutlet weak var colorButton2: UIButton!
    @IBOutlet weak var colorButton3: UIButton!
    @IBOutlet weak var colorButton4: UIButton!
    @IBOutlet weak var colorButton5: UIButton!
    @IBOutlet weak var colorButton6: UIButton!
    @IBOutlet weak var colorButton7: UIButton!
    @IBOutlet weak var colorButton8: UIButton!
    @IBOutlet weak var colorButton9: UIButton!
    
    @IBOutlet weak var fontButton: UIButton!
    @IBOutlet weak var fontSizeButton: UIButton!
    
    @IBOutlet weak var designCollectionView: UICollectionView!
    
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //앨범에서 선택한 이미지 띄우기
        imageView.image = selectedImage
        
        setColorButton(button: colorButton1, color: .white)
        setColorButton(button: colorButton2, color: .black)
        setColorButton(button: colorButton3, color: .red)
        setColorButton(button: colorButton4, color: .orange)
        setColorButton(button: colorButton5, color: .yellow)
        setColorButton(button: colorButton6, color: .green)
        setColorButton(button: colorButton7, color: .blue)
        setColorButton(button: colorButton8, color: .purple)
        setColorButton(button: colorButton9, color: .lightGray)
        
        fontButton.clipsToBounds = true
        fontButton.layer.cornerRadius = 10
        
        fontSizeButton.clipsToBounds = true
        fontSizeButton.layer.cornerRadius = 10
        
        
        
        designCollectionView.delegate = self
        designCollectionView.dataSource = self

        
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(closeButtonClicked))
        
        navigationItem.leftBarButtonItem?.tintColor = .orange
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "웨않나와", style: .plain, target: self, action: nil)

    }
    
    @objc func closeButtonClicked() {
        print(#function)
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    func setColorButton(button: UIButton, color: UIColor) {
        
        //컬러버튼 설정
        button.setTitle("", for: .normal)
        //button.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        //button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.black.cgColor

        button.layer.borderWidth = 2
        //button.backgroundColor = color
        button.clipsToBounds = true
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        
        
    }
    


}

extension ImageEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeStampDesignCell", for: indexPath) as?
                UICollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .lightGray
        
        return cell
    }
    
    
}
