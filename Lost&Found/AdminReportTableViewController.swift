//
//  AdminReportTableViewController.swift
//  Lost&Found
//
//  Created by gauri chavan on 4/27/18.
//  Copyright © 2018 gauri chavan. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import MessageUI

class AdminReportTableViewController: UITableViewController, UISearchBarDelegate, MFMailComposeViewControllerDelegate {
    @IBOutlet var adminTableView: UITableView!

    var alertController:UIAlertController = UIAlertController()
    
    var properties = [Property]()
    var filter = [Property]()
     var inSearchMode = false

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var adminReportTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAllTheReports()
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    
    
    
    func loadAllTheReports(){
        let postsRef = Database.database().reference().child("properties")
        
        
        postsRef.observe(.value, with: { snapshot in
            
            var tempDict = [Property]()
            for child in snapshot.children {
                
                if let childSnapshot = child as? DataSnapshot,
                    
                    let dict = childSnapshot.value as? [String:Any]{
                    
                        let propertyName = dict["propertyName"] as? String
                        let propertyDescription = dict["propertyDescription"] as? String
                        let propertyFoundOrLost = dict["propertyFoundOrLost"] as? String
                        let propertyId = dict["id"] as? String
                        let propertyImageURL = dict["propertyImageURL"] as? String
                        let url = URL(string:propertyImageURL!)
                        let proper_ = Property(propertyDescription:propertyDescription!,propertyName:propertyName!,propertyFoundOrLost:propertyFoundOrLost!,propertyId:propertyId!,propertyImageURL:url!)

                        tempDict.append(proper_)
                    }
            }
            self.properties = tempDict
            self.tableView.reloadData()
            
        })
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            
            view.endEditing(true)
            
            adminReportTableView.reloadData()
            
        } else {
            
            inSearchMode = true
            
            let ref = Database.database().reference().child("properties")
            
            ref.queryOrdered(byChild: "propertyName").queryStarting(atValue: searchText).queryEnding(atValue: searchText+"\u{f8ff}").observe(.value, with: { snapshot in
                
                
                var tempDict = [Property]()
                
                for child in snapshot.children {
                    
                    if let childSnapshot = child as? DataSnapshot,
                        
                    let dict = childSnapshot.value as? [String:Any]{
                        
                        let propertyName = dict["propertyName"] as? String
                        let propertyDescription = dict["propertyDescription"] as? String
                        let propertyFoundOrLost = dict["propertyFoundOrLost"] as? String
                        let propertyId = dict["id"] as? String
                        let propertyImageURL = dict["propertyImageURL"] as? String
                        let url = URL(string:propertyImageURL!)
                        let proper_ = Property(propertyDescription:propertyDescription!,propertyName:propertyName!,propertyFoundOrLost:propertyFoundOrLost!,propertyId:propertyId!,propertyImageURL:url!)
                   
                        tempDict.append(proper_)
                    }
                }
                self.filter = tempDict
                self.tableView.reloadData()
                
            })
            
        }
    }


    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear!!!!")
        
        adminReportTableView.reloadData()
        
        adminReportTableView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if inSearchMode {
            return filter.count
        }else{
            return properties.count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminReportIdentifier", for: indexPath) as! AdminReportTableViewCell
        
        if inSearchMode {
            
            let reportedData = filter[indexPath.row]
            cell.ReportHeading.text = reportedData.propertyName
            cell.subHeadinglabel.text = reportedData.propertyDescription
            ImageHandler.getImage(withURL: reportedData.propertyImageURL as URL) { image in
                cell.imageReport?.image = image
            }
            if reportedData.propertyFoundOrLost == "true"{
                cell.reportStatus.text = "FOUND"
            }else{
                cell.reportStatus.text = "LOST"
                
            }


        } else {
            
            let reportedData = properties[indexPath.row]
            
            cell.ReportHeading.text = reportedData.propertyName
            cell.subHeadinglabel.text = reportedData.propertyDescription
            ImageHandler.getImage(withURL: reportedData.propertyImageURL as URL) { image in
                cell.imageReport?.image = image
            }
            
            if reportedData.propertyFoundOrLost == "true"{
                cell.reportStatus.text = "FOUND"
            }else{
                cell.reportStatus.text = "LOST"

            }
            
        }
        
        return cell
    
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let property = properties[indexPath.row]
        
        alertController = UIAlertController(title:property.propertyName, message:"Please update the status of the property: True - Found / False - Lost ", preferredStyle:.alert)
        
        let updateAction = UIAlertAction(title:"Update", style:.default){(_) in
            
            let id = property.propertyId
            let propName = self.alertController.textFields?[0].text
            
            self.updateProperty(id: id, propertyFoundOrLost:propName!)
        }
        
        let deleteAction = UIAlertAction(title:"Delete", style:.default){(_) in
            
            self.deleteProperty(id:property.propertyId)
        }
        
        let closeAction = UIAlertAction(title:"Close", style:.default){(_) in
            
            self.closeProperty()
        }

        
        alertController.addTextField{(textField) in
            textField.text = property.propertyFoundOrLost
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        alertController.addAction(closeAction)

        
        present(alertController,animated: true,completion: nil)
        
    }
    
    
    func updateProperty(id: String, propertyFoundOrLost:String){
        
        let ref = Database.database().reference().child("properties")
        
        ref.child(id).updateChildValues(["propertyFoundOrLost": propertyFoundOrLost])
      
        /*let alert = UIAlertController(title: "SUCCESS", message: "Successfully Updated the Property!!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)*/
        
        
       /* var emailSend:Bool = false
        emailSend = validateEmailOnDone()
        if(emailSend == true){
            addEmailPresentViewController()
        }else{
            print("email error")
        }*/
        
        sendEmail()
        
       // return

        
    }
    
    func deleteProperty(id: String){
        let ref = Database.database().reference().child("properties")
        ref.child(id).setValue(nil)
        
        let alert = UIAlertController(title: "SUCCESS", message: "Successfully Deleted the Property!!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        return


    }
    
    func closeProperty(){
        alertController.dismiss(animated: true, completion: nil)
    }
    
    
    
    
   /* func validateEmailOnDone() -> Bool{
        
        
        if validateEmail(candidate: "gauric31@gmail.com")
        {
            
            
            addEmailPresentViewController()
            
            return true
        }else{
            
            var alert2 = UIAlertView(title: "Money Bank", message: "Enter valid Email -ID", delegate: self, cancelButtonTitle: "OK")
            
            alert2.show()
            
            
        }
        return false
        
    }
    
    
    func addEmailPresentViewController(){
        
        if(MFMailComposeViewController.canSendMail()) {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
            mailComposer.setSubject("Your Lost Property is Found")
            
            var messageBody :String = String()
            
            messageBody = "Thank you.."
            mailComposer.setMessageBody(messageBody, isHTML: false)
            mailComposer.setToRecipients(["gauric31@gmail.com"])
         }
        
        
    }
    
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }*/

    
   /* func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }*/
    
    
    
    func sendEmail() {
        //if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
            mail.setToRecipients(["chavan.gauri05@gmail.com"])
            mail.setSubject("hey")
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: false)
            
            
            if(MFMailComposeViewController.canSendMail()){
                self.present(mail, animated: true, completion: nil)
            }else{
                print("Error")
            }
            
            //present(mail, animated: true)
      //  } else {
            // show failure alert
      //  }
        
        
    }
    
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
