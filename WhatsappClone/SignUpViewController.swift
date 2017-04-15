//
//  SignUpViewController.swift
//  WhatsappClone
//
//  Created by Mayur on 15/04/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

   
    @IBOutlet var profileIV     : UIImageView!
    
    @IBOutlet var firstNameTF   : UITextField!
    @IBOutlet var lastNameTF    : UITextField!
    @IBOutlet var usernameTF    : UITextField!
    
    @IBOutlet var signUpBT      : UIButton!
    
    /****************** VARIABLES ***************/
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference() // Creating refernce of firebase database
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func SignUpAction(_ sender: Any) {
        
        var userDetail : NSMutableDictionary = NSMutableDictionary()
        userDetail.setValue(firstNameTF.text!, forKey: "first_name")
        userDetail.setValue(lastNameTF.text, forKey: "last_name")
        userDetail.setValue(usernameTF.text!, forKey: "user_name")
        
        self.ref.childByAutoId().setValue(["user_info": userDetail]) // Writing user detail into firbase database
    }
}
