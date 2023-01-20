//
//  DetailNewsViewController.swift
//  NewsMVVM Final
//
//  Created by Muhammad Hanif on 20/01/23.
//

import UIKit

class DetailNewsViewController: UIViewController {
    @IBOutlet var modelName: UILabel!
    @IBOutlet var modelDescription: UILabel!
    @IBOutlet var modelImage: UIImageView!
    
    var news: News? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if let result = news {
            modelName.text = result.title
            modelDescription.text = result.desc
            if let i = result.urlImage {
                modelImage.image = UIImage(url: URL(string: i))
            }
        }
    }
}
