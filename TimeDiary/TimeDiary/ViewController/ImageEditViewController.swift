//
//  ImageEditViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/18.
//

import UIKit

class ImageEditViewController: UIViewController {

    static let identifier = "ImageEditViewController"
    
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
        
        //컬러 버튼 setting
        setColorButton(button: colorButton1, color: .white)
        setColorButton(button: colorButton2, color: .black)
        setColorButton(button: colorButton3, color: .red)
        setColorButton(button: colorButton4, color: .orange)
        setColorButton(button: colorButton5, color: .yellow)
        setColorButton(button: colorButton6, color: .green)
        setColorButton(button: colorButton7, color: .blue)
        setColorButton(button: colorButton8, color: .purple)
        setColorButton(button: colorButton9, color: .lightGray)
        
        //폰트 선택 버튼 setting
        fontButton.clipsToBounds = true
        fontButton.layer.cornerRadius = 10
        
        //폰크 크기 조절 버튼 setting
        fontSizeButton.clipsToBounds = true
        fontSizeButton.layer.cornerRadius = 10
        
        //collection view setting
        designCollectionView.delegate = self
        designCollectionView.dataSource = self
        
        //collection view flow layout 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (spacing * 4) - 40
        layout.itemSize = CGSize(width: width / 3, height: (width / 3))
        print(UIScreen.main.bounds.width, width / 3, width / 3)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        designCollectionView.collectionViewLayout = layout

        
        //네비게이션 바 아이템 setting
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(closeButtonClicked))
        
        //navigationItem.leftBarButtonItem?.tintColor = .orange
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(nextButtonClicked))

    }
    
    @objc func closeButtonClicked() {
        print(#function)
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextButtonClicked() {
        print(#function)
        
        let st = UIStoryboard(name: "AddDiary", bundle: nil)
        if let vc = st.instantiateViewController(withIdentifier: AddDiaryViewController.identifier) as? AddDiaryViewController {
            
            vc.selectedImage = selectedImage
            vc.modalPresentationStyle = .fullScreen
                
            //navigation bar를 포함하여 다음 뷰 컨트롤러로 화면전환 - push
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeStampDesignCell", for: indexPath) as?
                UICollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .lightGray
        
        return cell
    }
    
    
}
