//
//  ImageEditViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/18.
//

import UIKit

class ImageEditViewController: UIViewController {

    static let identifier = "ImageEditViewController"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeStampView: UIView!
    @IBOutlet weak var designView: UIView!
    
    @IBOutlet weak var colorButton1: UIButton!
    @IBOutlet weak var colorButton2: UIButton!
    @IBOutlet weak var colorButton3: UIButton!
    @IBOutlet weak var colorButton4: UIButton!
    @IBOutlet weak var colorButton5: UIButton!
    @IBOutlet weak var colorButton6: UIButton!
    @IBOutlet weak var colorButton7: UIButton!
    @IBOutlet weak var colorButton8: UIButton!
    @IBOutlet weak var colorButton9: UIButton!
    
    //@IBOutlet weak var fontButton: UIButton!
    //@IBOutlet weak var fontSizeButton: UIButton!
    
    @IBOutlet weak var designCollectionView: UICollectionView!
    
    var selectedImage = UIImage()
    
 
    
//    lazy var scrollView: UIScrollView = {
//        let scrollView: UIScrollView = UIScrollView()
//        // Generate ScrollView.
//        scrollView.frame = self.timeStampView.frame
//        // Disable ScrollView bounces
//        scrollView.bounces = false
//        // Set the image in UIImage.
//        let image = selectedImage
//        // Create a UIImageView.
//        let imageView = UIImageView()
//        // Set myImage to the image of imageView.
//        imageView.image = image
//        // Set the value of frame size
//        imageView.frame.size = image.size
//        // Set the aspect ratio of the image.
//        imageView.contentMode = UIView.ContentMode.scaleAspectFill
//        // Add imageView to ScrollView.
//        scrollView.addSubview(imageView)
//        // Set contentSize to ScrollView.
//        scrollView.contentSize = imageView.frame.size
//
//        return scrollView
//
//    }()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageWidth = selectedImage.size.width
        let imageHeight = selectedImage.size.height
        
        let screenWidth = UIScreen.main.bounds.width - 40
        
        print(imageWidth, imageHeight, screenWidth)
       
        self.scrollView.alwaysBounceVertical = false
        self.scrollView.alwaysBounceHorizontal = false

//        self.scrollView.minimumZoomScale = 0.1
//        self.scrollView.maximumZoomScale = 2
        
        self.scrollView.center = self.timeStampView.center
        
        if imageWidth > imageHeight {

            //scrollView.
            self.scrollView.minimumZoomScale = screenWidth / imageHeight
            self.scrollView.maximumZoomScale = 4
            //print(imageHeight / screenWidth)
        } else {
            //scrollView.
            self.scrollView.minimumZoomScale = screenWidth / imageWidth
            self.scrollView.maximumZoomScale = 4
            //print(imageWidth / screenWidth)
        }
        
        self.scrollView.delegate = self
        
        //앨범에서 선택한 이미지 띄우기
        self.imageView.image = selectedImage
        self.scrollView.zoomScale = scrollView.minimumZoomScale
        
        //let customView: Desgin_1? = UIView.loadFromNib()
        let custom = Bundle.main.loadNibNamed("TimeStampDesign_1", owner: self, options: nil)?[0] as! TimeStampDesign_1
        
        self.designView.addSubview(custom)




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
        //fontButton.clipsToBounds = true
        //fontButton.layer.cornerRadius = 10
        
        //폰크 크기 조절 버튼 setting
        //fontSizeButton.clipsToBounds = true
        //fontSizeButton.layer.cornerRadius = 10
        
        //collection view setting
        designCollectionView.delegate = self
        designCollectionView.dataSource = self
        
        //collection view flow layout 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (spacing * 4) - 40
        layout.itemSize = CGSize(width: width / 3, height: (width / 3))
        //print(UIScreen.main.bounds.width, width / 3, width / 3)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        designCollectionView.collectionViewLayout = layout

        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.hidesBarsOnTap = false
        
        //네비게이션 바 아이템 setting
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(closeButtonClicked))
        
        //navigationItem.leftBarButtonItem?.tintColor = .orange
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String(NSLocalizedString("next", comment: "다음으로 이동")), style: .plain, target: self, action: #selector(nextButtonClicked))
        
        

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
        button.layer.borderColor = UIColor.lightGray.cgColor

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
                TimeStampDesignCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .lightGray
        
        return cell
    }
    
    
}



extension ImageEditViewController: UIScrollViewDelegate {
    

   @available(iOS 2.0, *)
   func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return self.imageView
   }
    
   func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //print(scrollView.zoomScale)
       scrollView.contentInset = .zero
   }
}

    

