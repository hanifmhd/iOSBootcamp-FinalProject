//
//  ProfileViewController.swift
//  NewsMVVM Final
//
//  Created by Muhammad Hanif on 20/01/23.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullnameView: UITextField!
    @IBOutlet weak var titleView: UITextField!
    @IBOutlet weak var buttonView: UIButton!
    
    @IBAction func edit(_ sender: UIButton) {
        if !stateEdit {
            stateEdit = true
        
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            imageView.addDashedBorder()
            
            fullnameView.isEnabled = true
            fullnameView.borderStyle = .roundedRect
            
            titleView.isEnabled = true
            titleView.borderStyle = .roundedRect
            
            buttonView.setTitle("Save", for: .normal)
            fullnameView.becomeFirstResponder()
        } else {
            let realm = try! Realm()
            try! realm.write {
                profile.fullname = fullnameView.text ?? ""
                profile.title = titleView.text ?? ""
                profile.image = (imageView.image?.jpegData(compressionQuality: 1))!
            }
            stateEdit = false
            let alert = UIAlertController(title: "Profile Updated", message: "Your profile has been updated.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.setupView()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private var profile: Profile!
    private var stateEdit = false
    private var imagePicker = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        let profiles = realm.objects(Profile.self)
        if profiles.count == 0 {
            profile = Profile()
            profile.fullname = "Muhammad Hanif"
            profile.title = "Front-End Developer"
            profile.image = imageToData("profile")
            try! realm.write {
                realm.add(profile)
            }
        } else {
            guard let p = profiles.first else { return }
            profile = p
        }
        
        setupView()
    }
    
    func imageToData(_ title: String) -> Data {
        guard let img = UIImage(named: title) else { return UIImage(systemName: "camera.fill")!.jpegData(compressionQuality: 1)! }
        var data = img.jpegData(compressionQuality: 1)!
        if data.count > 2097152 {
            let newSize = CGSize(width: 800, height: img.size.height / img.size.width * 800)
            let newImage = img.scaleImage(toSize: newSize)
            data = newImage!.jpegData(compressionQuality: 1)!
        }
        return data
    }
    
    func setupView() {
        imageView.image = UIImage(data: profile.image)?.addImagePadding(x: 40, y: 40)
        imageView.isUserInteractionEnabled = false
        imageView.layer.sublayers?.removeAll()
        
        fullnameView.text = profile.fullname
        fullnameView.isEnabled = false
        fullnameView.borderStyle = .none
        
        titleView.text = profile.title
        titleView.isEnabled = false
        titleView.borderStyle = .none
        
        buttonView.setTitle("Edit", for: .normal)
    }
    
}

// MARK: Image Picker Delegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: false) {
                self.imageView.image = image
            }
        } else {
            dismiss(animated: false)
        }
    }
}
