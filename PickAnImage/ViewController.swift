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
        pickerController.mediaTypes = ["public.image"]
    }
    //MARK: - Get Image from Photos
    @IBAction func browsePhoto(_ sender: UIBarButtonItem) {
        self.pickerController.sourceType = .photoLibrary
        
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    DispatchQueue.main.async {
                        self.present(self.pickerController, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    //MARK: - Get Image from Camera
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        self.pickerController.sourceType = .camera
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                DispatchQueue.main.async {
                    self.present(self.pickerController, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK: - Save Photo to Photos
    @IBAction func savePhoto(_ sender: AnyObject) {
        guard let image:UIImage = showImage.image else {return}
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
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
            DispatchQueue.main.async {
                self.showImage.image = image
            }
        }
        else{
            let ac = UIAlertController(title: "Error", message: "Can't access the image from scource.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .destructive))
            present(ac, animated: true)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - A function to save the image inside App Bunble. If needed, uncomment the bellow 👇 function block and call it from the a save button action.
    /*
    func saveImage(imageName: String){
       //create path to store image with an instance of the FileManager
       let fileManager = FileManager.default
       let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)

       let image = showImage.image!
     
       //Convert the image to PNG format
        let data = image.pngData()
     
       //Store the png image into the document directory
       fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    */
}

