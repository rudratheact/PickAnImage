//
//  ViewController.swift
//  PickAnImage
//
//  Created by Rudra Misra on 7/26/20.
//  Copyright © 2020 Rudra Misra. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var showImage: UIImageView!
    
    let pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
    }
    //MARK: Get Image from Photos
    @IBAction func browsPhoto(_ sender: UIBarButtonItem) {
        self.pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }
    //MARK: Get Image from Camera
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        self.pickerController.sourceType = .camera
        self.present(pickerController, animated: true, completion: nil)
    }
    
    //MARK: - Save Photo to Photos
    @IBAction func savePhoto(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(showImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    //MARK: - Check saving process for success
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .destructive))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved", message: "The image has been saved to the Photos app.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    //MARK: - Display Photo into Image View after processing it correclty
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image:UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.showImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

