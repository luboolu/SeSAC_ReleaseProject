//
//  UserTagAlbumDetailViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/29.
//

import UIKit

class UserTagAlbumDetailViewController: UIViewController {
    
    static let identifier = "UserTagAlbumDetailViewController"
    
    var tasksDiary: UserDiary!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let date = tasksDiary.date
        let timestamp1 = DateFormatter.yearDayFormat1.string(from: date)
        let timestamp2 = DateFormatter.timeFormat1.string(from: date)
        
        self.navigationItem.title = "\(timestamp1) \(timestamp2)"
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ellipsis.circle"), style: .plain, target: self, action: #selector(editButtonClicked))

        
        
        imageView.image = loadImageFromDocumentDirectory(imageName: "\(tasksDiary._id).png")
        
        contentView.isEditable = false
        contentView.text = tasksDiary.content
        contentView.font = UIFont().kotra_songeulssi_13
        
    }
    
    @objc func editButtonClicked() {
        print(#function)
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
