//
//  SettingsViewController.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/24/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit
import PromiseKit
import Toast_Swift

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var ipField: UITextField!
    @IBOutlet weak var portField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tappedConnectButton(_ sender: AnyObject) {
        let ip = ipField.text
        let port = Int(portField.text!)
        
        let library = Library.sharedInstance
        library.ip = ip
        library.port = port
        
        library.connectToServer().then { connected -> Void in
            if (connected) {
                self.view.makeToast("Connected", duration: 2.0, position: .center)
            } else {
                let alert = UIAlertController(title: "Error", message: "Failed to connect to server.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }.catch { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
