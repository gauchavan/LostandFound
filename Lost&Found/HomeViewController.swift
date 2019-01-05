//
//  SignOutViewController.swift
//  Lost&Found
//
//  Created by gauri chavan on 4/13/18.
//  Copyright © 2018 gauri chavan. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var signOutBtnLabel: UIBarButtonItem!
 
   
    @IBOutlet weak var reportHistoryBtn: UIButton!


    @IBAction func reportHistoryBtnFunc(_ sender: UIButton) {
        // performSegue(withIdentifier: "signoutIdentifier", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let username  = Auth.auth().currentUser?.displayName else {
            return
        }
        
        welcomeLabel.text = "Welcome \(username) !!!"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutBtnFunc(_ sender: Any) {
        do{
            
            try GIDSignIn.sharedInstance().signOut()
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            performSegue(withIdentifier: "signoutIdentifier", sender: nil)
        }catch{
            print("error in sign out")
            print(error)
        }
        
        
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
