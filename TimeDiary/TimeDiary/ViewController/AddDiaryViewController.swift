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

        imageView.image = selectedImage
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(saveButtonClicked))
    }
    
    @objc func saveButtonClicked() {
        print(#function)
        
        if let img = imageView.image {
            let vc = UIActivityViewController(activityItems: [img ], applicationActivities: [])
            self.present(vc, animated: true, completion: nil)
        }
        

    }
    
    

}
