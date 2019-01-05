//
//  ViewController.swift
//  Lost&Found
//
//  Created by gauri chavan on 4/12/18.
//  Copyright © 2018 gauri chavan. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var signInButton: GIDSignInButton!

    override func viewDidLoad() {
        print("view controller - view did load")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
       print("view did appear")
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        print("Credential \(credential)")
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("error")
                print(user?.email)
            
                return
            }
        
           // let s = self.getMainPart(s: (user?.email)!)
            //print(s)
            //if s.contains("husky.neu.edu"){
                if(user?.email != "chavan.gau@husky.neu.edu"){
                    print("User got signed in Firebase!!")
                    self.performSegue(withIdentifier: "signInIdentifier", sender: nil)
                }else{
                    print("Admin got signed in Firebase!!")
                    self.performSegue(withIdentifier: "AdminIdentifier", sender: nil)
                }
           /* }else{
                GIDSignIn.sharedInstance().signOut()
                return
            }*/
            
            

        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMainPart(s: String) -> String {
      //  var v = s.components(separatedBy: "@").last?.components(separatedBy: ".")
        var v = s.components(separatedBy: "@").last
      //  v?.removeLast()
        return (v)!
    }



}

