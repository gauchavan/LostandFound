//
//  HistoryViewController.swift
//  Lost&Found
//
//  Created by gauri chavan on 4/25/18.
//  Copyright © 2018 gauri chavan. All rights reserved.
//

import UIKit
import Firebase


class HistoryViewController: UIViewController {

     var historyDict: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadAllTheReports()
        
        // Do any additional setup after loading the view.
      /*  refHandle = historyProperty.observe(DataEventType.value, with: { (snapshot) in
            let dataDict = snapshot.value as? [String : AnyObject] ?? [:]
            print("History data \(dataDict)")
        })*/
        
        
        
        
       /* let userID = Auth.auth().currentUser?.uid
        historyProperty.child("properties").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let id = value?["id"] as? String ?? ""
            print("id == \(id)")
                       // ...
        }) { (error) in
            print(error.localizedDescription)
        }    }*/
        
        
        
        
    /*    let userID = Auth.auth().currentUser?.uid
        ref.child("properties").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            print(value)
            let propertyName = value?["propertyName"] as? String
            print(propertyName)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }*/
    }
    
    
    func loadAllTheReports(){
        let postsRef = Database.database().reference().child("properties")
        
        
        postsRef.observe(.value, with: { snapshot in
            
            
            for child in snapshot.children {
                
                if let childSnapshot = child as? DataSnapshot,
                    
                    let dict = childSnapshot.value as? [String:Any]
                    
                {
                   /* print(Auth.auth().currentUser?.uid)
                    print(dict["userId"] as? String)*/
                    if(dict["userId"] as? String == Auth.auth().currentUser?.uid){
                        
                        self.historyDict = dict
                        
                        let text = dict["propertyName"] as? String
                        print(self.historyDict)
                        
                    }
                }
                
            }
            
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
