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
    
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = selectedImage
        
        
        
    }
    


}
