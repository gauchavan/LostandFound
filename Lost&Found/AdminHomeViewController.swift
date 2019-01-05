//
//  AdminHomeViewController.swift
//  Lost&Found
//
//  Created by gauri chavan on 4/27/18.
//  Copyright © 2018 gauri chavan. All rights reserved.
//

import UIKit
import Firebase

class AdminHomeViewController: UIViewController {

    @IBOutlet weak var lostAndFoundReport: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var adminSignOut: UIBarButtonItem!
    
    @IBAction func lostAndFoundReportBtnFunc(_ sender: UIButton) {
    }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let username  = Auth.auth().currentUser?.displayName else {
            return
        }
        
        headingLabel.text = "Welcome \(username) !!!"
    }

    @IBAction func adminSignOutFunc(_ sender: UIBarButtonItem) {
        do{
            try GIDSignIn.sharedInstance().signOut()
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }

            performSegue(withIdentifier: "adminsignoutIdentifier", sender: nil)
        }catch{
            print("error in sign out")
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
