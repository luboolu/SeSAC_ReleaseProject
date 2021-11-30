//
//  UserTagAlbumViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/29.
//

import UIKit
import RealmSwift

class UserTagAlbumViewController: UIViewController {
    
    static let identifier = "UserTagAlbumViewController"
    
    let localRealm = try! Realm()
    
    var tagData: UserTag!
    var selectedTag: String!
    var tasksDiary: Results<UserDiary>!
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    @IBOutlet weak var guideLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        if tagData != nil {
            self.navigationItem.title = "\(tagData.tag)"
        } else {
            self.navigationItem.title = NSLocalizedString("all", comment: "전체")
        }
        
        
        
        if selectedTag == "All" {
            tasksDiary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "date", ascending: false)
        } else {
            tasksDiary = localRealm.objects(UserDiary.self).filter("tag = '\(tagData.tag)'")
        }
        
        //tasksDiary가 count 0이면 데이터를 추가해달라는 문구 추가
        if tasksDiary.count == 0 {
            albumCollectionView.isHidden = true
            guideLabel.isHidden = false
            
            guideLabel.text = NSLocalizedString("guide", comment: "가이드")
            guideLabel.font = UIFont().kotra_songeulssi_13
            
            
        } else {
            albumCollectionView.isHidden = false
            guideLabel.isHidden = true
        }
        
        
        
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        
        //collection view xib setting
        let nibName = UINib(nibName: TagAlbumCollectionViewCell.identifier, bundle: nil)
        albumCollectionView.register(nibName, forCellWithReuseIdentifier: TagAlbumCollectionViewCell.identifier)
        
        //collection view flow layout 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 0
        let width = UIScreen.main.bounds.width - (spacing * 4)
        layout.itemSize = CGSize(width: width / 3, height: (width / 3))
        //print(UIScreen.main.bounds.width, width / 3, width / 3)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        albumCollectionView.collectionViewLayout = layout
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        albumCollectionView.reloadData()
        
        //tasksDiary가 count 0이면 데이터를 추가해달라는 문구 추가
        if tasksDiary.count == 0 {
            albumCollectionView.isHidden = true
            guideLabel.isHidden = false
            
            guideLabel.text = NSLocalizedString("guide", comment: "가이드")
            guideLabel.font = UIFont().kotra_songeulssi_13
            
            
        } else {
            albumCollectionView.isHidden = false
            guideLabel.isHidden = true
        }
    }
    
    //도큐먼트 폴더 경로 -> 이미지 찾기 -> UIImage로 변환 -> UIImageView에 보여주기
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        //document에 image 폴더 만들기
        let folderPath =  documentDirectory.appendingPathComponent("timediray_image")
        

        let imageURL = URL(fileURLWithPath: folderPath.absoluteString).appendingPathComponent(imageName)
        
        if let image = UIImage(contentsOfFile: imageURL.path) {
            return image
        }
        
        return nil
    }

}


extension UserTagAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tasksDiary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagAlbumCollectionViewCell.identifier, for: indexPath) as? TagAlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let row = tasksDiary[indexPath.row]

        
        if let image = loadImageFromDocumentDirectory(imageName: "\(row._id).png") {
            cell.albumImageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //컬렉션뷰 선택되면 화면전환
        let st = UIStoryboard(name: "UserTagAlbumDetail", bundle: nil)
        if let vc = st.instantiateViewController(withIdentifier: UserTagAlbumDetailViewController.identifier) as? UserTagAlbumDetailViewController {
            
            
            vc.tasksDiary = self.tasksDiary[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
                
            //navigation bar를 포함하여 다음 뷰 컨트롤러로 화면전환 - push
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    
}
