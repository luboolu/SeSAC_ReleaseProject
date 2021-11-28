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
    
    @IBOutlet weak var designCollectionView: UICollectionView!
    
    var selectedImage = UIImage() //앨범, 카메라에서 선택한 사진 전달받을 변수
    var customView: UIView! //타임스탬프 디자인을 담을 view
    var stampDesignName = StampDesign.Stamp_1 //디자인 초기값
    var stampDesignColor = UIColor.white //디자인 색상 초기값
    

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.hidesBarsOnTap = false
        
        //네비게이션 바 아이템 setting
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(closeButtonClicked))
        
        //navigationItem.leftBarButtonItem?.tintColor = .orange
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String(NSLocalizedString("next", comment: "다음으로 이동")), style: .plain, target: self, action: #selector(nextButtonClicked))
        

        //self.view.reloadInputViews()
        
        //ScrollView zoom 관련 설정
        let imageWidth = selectedImage.size.width
        let imageHeight = selectedImage.size.height
        let screenWidth = UIScreen.main.bounds.width - 40
        

        self.scrollView.alwaysBounceVertical = false
        self.scrollView.alwaysBounceHorizontal = false

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
        
        //scrollView 초기 zoom scale 설정
        self.scrollView.zoomScale = scrollView.minimumZoomScale

        //기본 타임 스탬프 디자인 보여주기
        self.stampDesignColor = .white
        
        
        DispatchQueue.global().async {
            // UI 업데이트 전 실행되는 코드
            DispatchQueue.main.sync {
                // UI 업데이트
                self.designUpdate()
            }
            // UI 업데이트 후 실행되는 코드
        }
        

        //컬러 버튼 setting
        setColorButton(button: colorButton1, color: .white)
        setColorButton(button: colorButton2, color: .black)
        setColorButton(button: colorButton3, color: UIColor().blue)
        setColorButton(button: colorButton4, color: UIColor().green)
        setColorButton(button: colorButton5, color: UIColor().yellow)
        setColorButton(button: colorButton6, color: UIColor().orange)
        setColorButton(button: colorButton7, color: UIColor().red)
        setColorButton(button: colorButton8, color: UIColor().pink)
        setColorButton(button: colorButton9, color: UIColor().purple)
        
        
        //collection view setting
        designCollectionView.delegate = self
        designCollectionView.dataSource = self
        
        //collection view xib setting
        let nibName = UINib(nibName: DesignCollectionViewCell.identifier, bundle: nil)
        designCollectionView.register(nibName, forCellWithReuseIdentifier: DesignCollectionViewCell.identifier)
        
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
            
            
            let render = UIGraphicsImageRenderer(size: self.timeStampView.bounds.size)
            let image = render.image { (context) in
                self.timeStampView.drawHierarchy(in: self.timeStampView.bounds, afterScreenUpdates: true)
            }
            vc.selectedImage = image
            vc.modalPresentationStyle = .fullScreen
                
            //navigation bar를 포함하여 다음 뷰 컨트롤러로 화면전환 - push
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    
    
    @IBAction func whiteColorButtonClicked(_ sender: UIButton) {
        self.stampDesignColor = .white
        self.designUpdate()
    }
    
    @IBAction func blackColorButtonClicked(_ sender: UIButton) {
        self.stampDesignColor = .black
        self.designUpdate()
    }
    
    
    @IBAction func blueColorButtonClicked(_ sender: UIButton) {
        self.stampDesignColor = UIColor().blue
        self.designUpdate()
    }
    
    @IBAction func greenColorButtonClicked(_ sender: UIButton) {
        self.stampDesignColor = UIColor().green
        self.designUpdate()
    }
    
    @IBAction func yellowColorButtonClicked(_ sender: UIButton) {
        self.stampDesignColor = UIColor().yellow
        self.designUpdate()
    }
    
    @IBAction func orangeColorButtonClicked(_ sender: UIButton) {
        self.stampDesignColor = UIColor().orange
        self.designUpdate()
    }
    
    @IBAction func redColorButtonClicked(_ sender: UIButton) {
        self.stampDesignColor = UIColor().red
        self.designUpdate()
    }
    
    
    @IBAction func pinkColorButtonClicked(_ sender: UIButton) {
        self.stampDesignColor = UIColor().pink
        self.designUpdate()
    }
    
    @IBAction func purpleColorButtonClicked(_ sender: UIButton) {
        self.stampDesignColor = UIColor().purple
        self.designUpdate()
    }
    
    
    
    
    
    
    
    func setColorButton(button: UIButton, color: UIColor) {
        DispatchQueue.global().async {
            // UI 업데이트 전 실행되는 코드
            DispatchQueue.main.sync {
                //컬러버튼 설정
                button.setTitle("", for: .normal)
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.layer.borderWidth = 2
                button.backgroundColor = color
                button.clipsToBounds = true
                button.layer.cornerRadius = 0.5 * button.bounds.size.width
            }
            // UI 업데이트 후 실행되는 코드
        }

        
        
    }
    
    func designUpdate() {
        print(#function)
        print(self.designView.subviews.count)
        //subView가 쌓이지 않게 새로 추가하기 전에 삭제
        if self.designView.subviews.count > 0 {
            self.customView.removeFromSuperview()
        }
        
        print(UIScreen.main)
        print("timestampview:\(self.timeStampView.frame)")
        print("designview   :\(self.designView.frame)")
        print("scrollview   :\(self.scrollView.frame)")
        print("imageview    :\(self.imageView.frame)")
        
        //self.designView.frame = self.timeStampView.frame

        if self.stampDesignName == .Stamp_1 {
            self.customView = Stamp_1(frame: self.designView.frame, color: self.stampDesignColor)

        } else if self.stampDesignName == .Stamp_2 {
            self.customView = Stamp_2(frame: self.designView.frame, color: self.stampDesignColor)
            
        } else if self.stampDesignName == .Stamp_3 {
            self.customView = Stamp_3(frame: self.designView.frame, color: self.stampDesignColor)
            
        } else {
            
        }

        self.designView.addSubview(self.customView)
        self.designView.layer.zPosition = 999
        self.designView.reloadInputViews()
        
    }
    
    


}

extension ImageEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeStampDesignCell", for: indexPath) as?
//                TimeStampDesignCollectionViewCell else {
//            return UICollectionViewCell()
//        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesignCollectionViewCell.identifier, for: indexPath) as? DesignCollectionViewCell else {
            return UICollectionViewCell()
            
        }
        cell.backgroundColor = .lightGray
        cell.imageView.image = self.imageView.image
        cell.numLabel.text = "\(indexPath.row + 1)"
        cell.numLabel.font = UIFont().kotra_songeulssi_30
        
//        if indexPath.row == 0 {
//            let tmpDesignView = Stamp_1(frame: cell.frame, color: .white)
//            cell.designView.addSubview(tmpDesignView)
//        } else if indexPath.row == 1 {
//            let tmpDesignView = Stamp_2(frame: cell.frame, color: .white)
//            cell.designView.addSubview(tmpDesignView)
//        } else if indexPath.row == 2 {
//
//        } else if indexPath.row == 3 {
//
//        } else if indexPath.row == 4 {
//
//        } else if indexPath.row == 5 {
//
//        } else if indexPath.row == 6 {
//
//        } else if indexPath.row == 7 {
//
//        } else if indexPath.row == 8 {
//
//        } else if indexPath.row == 9 {
//
//        } else {
//
//        }
//
        cell.designView.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.65))

        cell.numLabel.layer.zPosition = 999
        cell.designView.layer.zPosition = 250
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.stampDesignName = .Stamp_1
        } else if indexPath.row == 1 {
            self.stampDesignName = .Stamp_2
        } else if indexPath.row == 2 {
            self.stampDesignName = .Stamp_3
        } else {
            
        }
        
        self.designUpdate()
        
    }
    
}


extension ImageEditViewController: UIScrollViewDelegate {
    

   @available(iOS 2.0, *)
   func viewForZooming(in scrollView: UIScrollView) -> UIView? {
       return self.imageView
   }
    
   func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print(scrollView.zoomScale)
       scrollView.contentInset = .zero
       //self.designUpdate()
   }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        print(#function)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print(#function)
    }
}

extension UIView {
    
    func asImage() -> UIImage {
          let renderer = UIGraphicsImageRenderer(bounds: bounds)
          return renderer.image { rendererContext in
              layer.render(in: rendererContext.cgContext)
          }
      }
    
    class func image(view: UIView, subview: UIView? = nil) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
    
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()
        
        if(subview != nil){
            var rect = (subview?.frame)!
            rect.size.height *= image.scale  //MOST IMPORTANT
            rect.size.width *= image.scale    //TOOK ME DAYS TO FIGURE THIS OUT
            let imageRef = image.cgImage!.cropping(to: rect)
            image = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
        }
        
        print(image.size.width, image.size.height)
        
        return image
    }
    
    func image() -> UIImage? {
        return UIView.image(view: self)
    }
    
    func image(withSubview: UIView) -> UIImage? {
        return UIView.image(view: self, subview: withSubview)
    }
}

