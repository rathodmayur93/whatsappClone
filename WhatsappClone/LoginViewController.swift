//
//  LoginViewController.swift
//  WhatsappClone
//
//  Created by Mayur on 15/04/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ref = FIRDatabase.database().reference() // your ref ie.root.child("users").child("user_detail")
       
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            //print(snapshot)
            
            for task in snapshot.children {
                guard let taskSnapshot = task as? FIRDataSnapshot else {
                    continue
                }
                
                let id = taskSnapshot.key // Retrieving Child Auto Id From Firebase Database
                
                let userDict = snapshot.value as? NSDictionary // Getting User Info Data
                
                let userInfoDict = userDict?.value(forKeyPath: "\(id).user_info") as! NSDictionary
                let username     = userInfoDict["user_name"] as! String // Getting Username
                print("Username \(username)")
                
                if(username == "rathodmayur93"){
                    print("Valid User")
                }
            }

            
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
