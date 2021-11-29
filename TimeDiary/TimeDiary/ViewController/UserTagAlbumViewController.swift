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
    var tasksDiary: Results<UserDiary>!
    
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tagData.tag)
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "\(tagData.tag)"
        
        
        if tagData.tag == "All" {
            tasksDiary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "date", ascending: false)
        } else {
            tasksDiary = localRealm.objects(UserDiary.self).filter("tag = '\(tagData.tag)'")
        }
        
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        
        //collection view xib setting
        let nibName = UINib(nibName: TagAlbumCollectionViewCell.identifier, bundle: nil)
        albumCollectionView.register(nibName, forCellWithReuseIdentifier: TagAlbumCollectionViewCell.identifier)
        
        //collection view flow layout 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 0
        let width = UIScreen.main.bounds.width - (spacing * 6)
        layout.itemSize = CGSize(width: width / 5, height: (width / 5))
        //print(UIScreen.main.bounds.width, width / 3, width / 3)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        albumCollectionView.collectionViewLayout = layout
        
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
        
        cell.albumImageView.image = row.
        
        return cell
    }
    
    
    
    
}
