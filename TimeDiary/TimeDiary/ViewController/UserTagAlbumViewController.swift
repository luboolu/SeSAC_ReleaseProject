//
//  UserTagAlbumViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/29.
//

import UIKit
import RealmSwift
import CoreHaptics

class UserTagAlbumViewController: UIViewController {
    
    static let identifier = "UserTagAlbumViewController"
    
    let localRealm = try! Realm()
    let DidDismissPostCommentViewController: Notification.Name = Notification.Name("DidDismissPostCommentViewController")
    
    var tagData: UserTag!
    var selectedTag: String!
    var tasksDiary: Results<UserDiary>!
    var hapticFeedbackGenerator: UISelectionFeedbackGenerator?
    
    //폴더 이동 모드인지 아닌지
    var moveMode = false {
        didSet(mode) {
            print("모드가 \(mode)에서 \(moveMode)로 변경되었습니다.")
            self.albumCollectionView.reloadData()
        }
    }
    
    var selectedList: [Bool] = []
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    @IBOutlet weak var guideLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissPostCommentNotification(_:)), name: DidDismissPostCommentViewController, object: nil)
        
        //햅틱셀렉션피드백
        hapticFeedbackGenerator = UISelectionFeedbackGenerator()
        hapticFeedbackGenerator?.prepare()
        
        self.tabBarController?.tabBar.isHidden = false
        
        
        // Do any additional setup after loading the view.
        if tagData != nil {
            self.navigationItem.title = "\(tagData.tag)"
        } else {
            self.navigationItem.title = NSLocalizedString("all", comment: "전체")
        }
        
        
        
        if selectedTag == "All" {
            tasksDiary = localRealm.objects(UserDiary.self).sorted(byKeyPath: "date", ascending: false)
        } else {
            selectedListAndDataInit()
        }
        
        //tasksDiary가 count 0이면 데이터를 추가해달라는 문구 추가
        if tasksDiary.count == 0 {
            albumCollectionView.isHidden = true
            guideLabel.isHidden = false
            
            guideLabel.text = NSLocalizedString("guide", comment: "가이드")
            guideLabel.font = UIFont().kotra_songeulssi_13
            
            
        } else {
            if selectedTag != "All" {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "이동", style: .plain, target: self, action: #selector(moveStartButtonClicked))
            }
            
            albumCollectionView.isHidden = false
            guideLabel.isHidden = true
            
            //날짜별로 데이터 분류하기
            //print(tasksDiary)
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
        print("TagAlbum\(#function)")
        albumCollectionView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "이동", style: .plain, target: self, action: #selector(moveStartButtonClicked))
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont().kotra_songeulssi_20]
        
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = UIColor(named: "bear")
        
        self.moveMode = false
        
        selectedListAndDataInit()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @objc func moveStartButtonClicked() {
        print(#function)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(moveEndButtonClicked))
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont().kotra_songeulssi_20]
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "bear")
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.moveMode = true
    }
    
    @objc func moveEndButtonClicked() {
        print(#function)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "이동", style: .plain, target: self, action: #selector(moveStartButtonClicked))
        movingData()
        self.moveMode = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont().kotra_songeulssi_20]
        
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = UIColor(named: "bear")
    }
    
    @objc func didDismissPostCommentNotification(_ noti: Notification) {
        //notification center로 reload하는 부분!!?!뭐지?!
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                self.viewDidLoad()
                self.albumCollectionView.reloadData()
            }
        }

    }
    
    func movingData() {
        print(#function)
        
        if self.selectedList.contains(true) {
            print("이동시킬 항목이 선택되었습니다!")
            print(self.selectedList)
            
            var selectedTasks: [UserDiary] = []

            for i in 0...tasksDiary.count - 1 {
                if self.selectedList[i] {
                    print(type(of: tasksDiary[i]))
                    selectedTasks.append(tasksDiary[i])
                }
            }
            
            let st = UIStoryboard(name: "UserTagSelect", bundle: nil)
            if let vc = st.instantiateViewController(withIdentifier: UserTagSelectViewController.identifier) as? UserTagSelectViewController {
                
                vc.selectedData = selectedTasks
                vc.modalPresentationStyle = .automatic
                
                //self.navigationController?.present(vc, animated: true, completion: nil)
                
                //self.navigationController?.present(vc, animated: true, completion: nil)
                self.present(vc, animated: true, completion: nil)
                //vc.modalPresentationStyle = .
                    
                //navigation bar를 포함하여 다음 뷰 컨트롤러로 화면전환 - push
                //self.navigationController?.pushViewController(vc, animated: true)
            }
            
            //tagSelect화면 보여주기

            
            print(selectedTasks)
            

            
            selectedListAndDataInit()
            
        } else {
            print("선택된 항목이 없습니다!")
        }
        
        self.albumCollectionView.reloadData()
    }
    
    func selectedListAndDataInit() {
        if tagData != nil {
            tasksDiary = localRealm.objects(UserDiary.self).filter("tag = '\(tagData.tag)'").sorted(byKeyPath: "date", ascending: false)
            self.selectedList.removeAll()
            
            if tasksDiary.count > 0 {
                for _ in 0...tasksDiary.count - 1 {
                    self.selectedList.append(false)
                }
            }
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
    
    
//    func generateHapticFeedback(for hapticFeedback: HapticFeedback) {
//        switch hapticFeedback {
//        case .selection:
//            // Initialize Selection Feedback Generator
//            let feedbackGenerator = UISelectionFeedbackGenerator()
//
//            // Trigger Haptic Feedback
//            feedbackGenerator.selectionChanged()
//        case .impact(let feedbackStyle):
//            // Initialize Impact Feedback Generator
//            let feedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
//
//            // Trigger Haptic Feedback
//            feedbackGenerator.impactOccurred()
//        case .notification(let feedbackType):
//            // Initialize Notification Feedback Generator
//            let feedbackGenerator = UINotificationFeedbackGenerator()
//
//            // Trigger Haptic Feedback
//            feedbackGenerator.notificationOccurred(feedbackType)
//        }
//    }
    

    

}


extension UserTagAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
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
        
        //move mode에 따른 동그라미 이미지 보여주기
        if self.moveMode {
            cell.selectedButton.isHidden = false
            
            if self.selectedList[indexPath.row] {
                cell.selectEffect.isHidden = false
                cell.selectedButton.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                cell.selectEffect.isHidden = true
                cell.selectedButton.image = UIImage(systemName: "circle")
                
            }
        } else {
            cell.selectEffect.isHidden = true
            cell.selectedButton.isHidden = true
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //self.hapticFeedbackGenerator?.selectionChanged()
        
        if self.moveMode {
            print("select!\(indexPath)")
            self.selectedList[indexPath.row] = !self.selectedList[indexPath.row]
            collectionView.reloadItems(at: [indexPath])
            
        } else {
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
    
    
    
    
}
