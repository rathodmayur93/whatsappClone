//
//  LoginViewController.swift
//  WhatsappClone
//
//  Created by Mayur on 15/04/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit
import Firebase

var userInfoList     = [UserInfoModel]()
let uiutil           = UiUtillity()

var userNameArray    : [String] = []
var loginUserName    = ""

class LoginViewController: UIViewController {

    @IBOutlet var usernameTF    : UITextField!
    @IBOutlet var loginBT       : UIButton!
    
    var isValidUsername         = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }

    @IBAction func loginAction(_ sender: Any) {
        
        uiutil.showIndicatorLoader()
        userInfoList.removeAll()
        retrieveUserInfoFromFirebase()
    }
    
    
    func retrieveUserInfoFromFirebase(){
    
        
        
        let ref = FIRDatabase.database().reference() // your ref ie.root.child("users").child("user_detail")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return }
            //print(snapshot)
            
            for task in snapshot.children {
                guard let taskSnapshot = task as? FIRDataSnapshot else {
                    continue
                }
                
                let id = taskSnapshot.key                                       // Retrieving Child Auto Id From Firebase Database
                
                let userDict = snapshot.value as? NSDictionary                  // Getting User Info Data
                
                let userInfoDict = userDict?.value(forKeyPath: "\(id).user_info") as! NSDictionary
                
                let userInfo          = UserInfoModel()
                
                let userName          = userInfoDict["user_name"] as! String             // Getting Username
                userInfo.uniqueId     = id                                               // Getting Unique Id
                userInfo.firstName    = userInfoDict["first_name"] as! String            // Getting First Name
                userInfo.lastName     = userInfoDict["last_name"] as! String             // Getting Last Name
                userInfo.userName     = userName
                // print("Username \(username) & \(firstName) & \(lastName)")
                
                userInfoList.append(userInfo)
                
                if(userName == self.usernameTF.text!){
                    loginUserName = userName
                    self.isValidUsername = true
                }else{
                    userNameArray.append(userInfoDict["first_name"] as! String)
                }
            }
            
            if(self.isValidUsername){
                uiutil.hideIndicatorLoader()
                uiutil.navigateToScreen(identifierName: "ViewController", fromController: self)
                print("Let's go and have chat")
            }else{
                uiutil.hideIndicatorLoader()
                uiutil.showAlert(title: "", message: "Ooops.. Username is either invalid or doesn't exist.", logMessage: "invalid username", fromController: self)
            }
        })
    }
}
