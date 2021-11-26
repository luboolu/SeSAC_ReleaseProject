//
//  AddDiaryViewController.swift
//  TimeDiary
//
//  Created by 김진영 on 2021/11/20.
//

import UIKit

class AddDiaryViewController: UIViewController {
    
    static let identifier = "AddDiaryViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(selectedImage.size.width, selectedImage.size.height)
        imageView.backgroundColor = .systemPink
        imageView.image = selectedImage
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String(NSLocalizedString("save", comment: "저장")), style: .plain, target: self, action: #selector(saveButtonClicked))
        
        titleTextView.text = "Title"
        titleTextView.font = UIFont().kotra_songeulssi_13
        
        contentTextView.text = "content"
        contentTextView.font = UIFont().kotra_songeulssi_13
        
    }
    
    @objc func saveButtonClicked() {
        print(#function)
        

        let vc = UIActivityViewController(activityItems: [selectedImage], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
        
        

    }
    
    

}
