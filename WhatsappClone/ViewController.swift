//
//  ViewController.swift
//  WhatsappClone
//
//  Created by Mayur on 14/04/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var userListTableView : UITableView!
    var ref                         : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return userNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = userListTableView.dequeueReusableCell(withIdentifier: "Cell") as! UserListTableViewCell
        cell.userNameLabel.text = userNameArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatScreenVC                = ChatScreenViewController()
        chatScreenVC.senderDisplayName  = userInfoList[indexPath.row].firstName
        chatScreenVC.userRef            = FIRDatabase.database().reference().child(userInfoList[0].uniqueId)
        
        uiutil.navigateToScreen(identifierName: "ChatScreenViewController", fromController: self)
        
    }

}

