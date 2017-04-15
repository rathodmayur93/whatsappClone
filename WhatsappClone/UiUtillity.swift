//
//  UiUtillity.swift
//  WhatsappClone
//
//  Created by Mayur on 15/04/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit
import SystemConfiguration

class UiUtillity: UIViewController {

    let spinningActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let container: UIView = UIView()
    
    let appColors = AppColors()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func showAlert(title: String, message: String, logMessage: String, fromController controller: UIViewController){
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: "Notification", message:message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            controller.present(alertController, animated: true, completion: nil)
            print(logMessage)
        }
    }
    
    func navigateToScreen(identifierName : String, fromController controller: UIViewController){
        
        OperationQueue.main.addOperation {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: identifierName) as UIViewController
            controller.present(vc, animated: true, completion: nil)
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func showIndicatorLoader(){
        
        let window                      = UIApplication.shared.keyWindow
        container.frame                 = UIScreen.main.bounds
        container.backgroundColor       = UIColor(hue: 0/360, saturation: 0/100, brightness: 0/100, alpha: 0.4)
        
        let loadingView: UIView         = UIView()
        loadingView.frame               = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center              = container.center
        loadingView.backgroundColor     = hexStringToUIColor(hex: appColors.toolbarColor)
        loadingView.clipsToBounds       = true
        loadingView.layer.cornerRadius  = 40
        
        spinningActivityIndicator.frame                         = CGRect(x: 0, y: 0, width: 40, height: 40)
        spinningActivityIndicator.hidesWhenStopped              = true
        spinningActivityIndicator.activityIndicatorViewStyle    = UIActivityIndicatorViewStyle.whiteLarge
        spinningActivityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(spinningActivityIndicator)
        container.addSubview(loadingView)
        window?.addSubview(container)
        spinningActivityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hideIndicatorLoader(){
        
        spinningActivityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
}
