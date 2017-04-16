//
//  SignUpViewController.swift
//  WhatsappClone
//
//  Created by Mayur on 15/04/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    @IBOutlet var profileIV     : UIImageView!
    
    @IBOutlet var firstNameTF   : UITextField!
    @IBOutlet var lastNameTF    : UITextField!
    @IBOutlet var usernameTF    : UITextField!
    
    @IBOutlet var signUpBT      : UIButton!
    
    var base64Encoded = ""
    
    /****************** VARIABLES ***************/
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference() // Creating refernce of firebase database
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func setUI(){
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        tapGesture.numberOfTapsRequired = 1
        profileIV.isUserInteractionEnabled = true
        profileIV.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func SignUpAction(_ sender: Any) {
        
        var userDetail : NSMutableDictionary = NSMutableDictionary()
        userDetail.setValue(firstNameTF.text!, forKey: "first_name")
        userDetail.setValue(lastNameTF.text, forKey: "last_name")
        userDetail.setValue(usernameTF.text!, forKey: "user_name")
        //userDetail.setValue(base64Encoded, forKey: "profile_photo")
        
        self.ref.childByAutoId().setValue(["user_info": userDetail]) // Writing user detail into firbase database
    }
    
    func showActionSheet(){
    
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Take Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("From Camera")
            self.openCameraButton()
        })
        let saveAction = UIAlertAction(title: "Choose Photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("From Gallery")
            self.fromGallery()
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func fromGallery(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func openCameraButton() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker             = UIImagePickerController()
            imagePicker.delegate        = self
            imagePicker.sourceType      = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing   = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            
            uiutil.showAlert(title: "", message: "Oops. Look like this device doesn't have camera", logMessage: "NO camera in device", fromController: self)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
    
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileIV.image = chosenImage
        dismiss(animated: true, completion: nil)
        var data        = NSData()
        data            = UIImagePNGRepresentation(profileIV.image!)! as NSData
        
        let storageRef   = FIRStorage.storage().reference()
        let profilePhoto = storageRef.child("profile_photo/")
        
        let uploadTask = profilePhoto.put(data as Data, metadata: nil) { (metadata, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL
            print("Image Upload URL \(downloadURL)")
        }

    }
}
