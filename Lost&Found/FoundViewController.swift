//
//  FoundViewController.swift
//  Lost&Found
//
//  Created by gauri chavan on 4/21/18.
//  Copyright © 2018 gauri chavan. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class FoundViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var addPicture: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var propertyNameTextField: UITextField!
    
    @IBOutlet weak var addLocationBtn: UIButton!
  
    @IBOutlet weak var propertyFoundDate: UITextField!
    @IBOutlet weak var propertyDescriptionTextField: UITextField!
    
    
    var myDatePicker:UIDatePicker = UIDatePicker()
    var foundProperty: DatabaseReference!
    
    var firebaseURL:String = ""
    
    var UserId:String = ""
    
    var dateSelected:String = ""
    
    var dateSelected_:Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDate()
        
        addToolBar()
        
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + 100)
        
        propertyFoundDate.delegate = self
        
        foundProperty = Database.database().reference().child("properties")
        
        guard let userId  = Auth.auth().currentUser?.uid else {
            return
        }
        
        UserId = userId
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //NotificationCenter.default.removeObserver(self)
    }

  
    func addProperties()
    {
        var lat:String = String(latitude)
        var long:String = String(longitude)
        
        let key = foundProperty.childByAutoId().key
        let prop = ["id":key,
                      "propertyName": propertyNameTextField.text as! String,
                      "propertyDescription": propertyDescriptionTextField.text as! String,
                      "propertyFoundDate": propertyFoundDate.text as! String,
                      "propertyFoundlatitude": lat as! String,
                      "propertyFoundlongitude": long as! String,
                      "propertyImageURL": firebaseURL,
                      "propertyFoundOrLost": "true",
                      "userId" : UserId
                          ] as [String : Any]
        
        foundProperty.child(key).setValue(prop)
    
        propertyNameTextField.text = ""
        propertyFoundDate.text = ""
        propertyDescriptionTextField.text = ""
        addPicture.image = nil
        latitude = 0
        longitude = 0
        
        
        let alert = UIAlertController(title: "SUCCESS", message: "Found Report Submitted Successfully!!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        return
        
        
        

    }

    
    @IBAction func addLocationBtnFunc(_ sender: UIButton) {
    
    }
    
    func addDate(){
        myDatePicker.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 200)
        myDatePicker.datePickerMode = .date
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.backgroundColor = UIColor.white
        myDatePicker.layer.cornerRadius = 5.0
        
        let calendar = Calendar(identifier: .gregorian)
        
        let currentDate = Date()
        
        var comps = DateComponents()
        
        let maxDate = calendar.date(byAdding: comps, to: currentDate)
        
        comps.year = 100
        
        let minDate = calendar.date(byAdding: comps, to: currentDate)
        
        myDatePicker.maximumDate = maxDate
        myDatePicker.minimumDate = minDate
        myDatePicker.addTarget(self, action: #selector(self.dataPickerChanged(datePicker:)), for: .valueChanged)
  
        self.propertyFoundDate.inputView = myDatePicker
        
    }
    
    @objc func dataPickerChanged(datePicker: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: datePicker.date)
        if propertyFoundDate.isFirstResponder{
            propertyFoundDate.text = selectedDate
            dateSelected = propertyFoundDate.text!
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.propertyFoundDate.resignFirstResponder()
    }

    
    func donePicker(){
        if propertyFoundDate.isFirstResponder{
            propertyFoundDate.text = dateSelected
            propertyFoundDate.resignFirstResponder()
        }
    }

    func cancelPicker(){
        self.propertyFoundDate.resignFirstResponder()
    }

    @IBOutlet weak var submitBtnFound: UIButton!

    @IBAction func submitBtnFormFoundFunction(_ sender: UIButton) {
        
        var propertyname = propertyNameTextField.text!
        
        if(propertyname.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            let alert = UIAlertController(title: "ALERT", message: "Property Name Field is empty!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var propertydescription = propertyDescriptionTextField.text!
        
        if(propertydescription.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            let alert = UIAlertController(title: "ALERT", message: "Property Description Field is empty!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        var propertydate = propertyFoundDate.text!
        
        if(propertydate.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            let alert = UIAlertController(title: "ALERT", message: "Property Date Field is empty!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        var start_Date: Date = Date()

        
        if let sdate = dateFormatterGet.date(from: propertydate){
            start_Date = sdate
        }else{
            let alert = UIAlertController(title: "ALERT", message: "Invalid Date!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
       
        if(latitude == 0){
            let alert = UIAlertController(title: "ALERT", message: "Latitude value is not set!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if(longitude == 0){
            let alert = UIAlertController(title: "ALERT", message: "Longitude value is not set!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        var url = firebaseURL
        if(url.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            let alert = UIAlertController(title: "ALERT", message: "Image is not stored in Firebase!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
       addProperties()
    }
    @IBAction func addPictureBtnFunc(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing =  false
        self.present(image, animated: true){}
    }
    
    var image_name = 0
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        guard let mediaType:String = info[UIImagePickerControllerMediaType] as? String else {
            dismiss(animated: true,completion: nil)
            return
        }
        
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imageData = UIImageJPEGRepresentation(originalImage, 0.8){
                addPicture.image = originalImage
                image_name = imageData.hashValue
                uploadImageToFirebaseStorage(data: imageData as NSData, image_name: image_name)
            }
        
       /* if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
           
        }else{
            //error message
        }*/

        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func uploadImageToFirebaseStorage(data: NSData, image_name:Int){
        let randomNum:UInt32 = arc4random_uniform(10000) // range is 0 to 99
        
        let storageRef = Storage.storage().reference(withPath: "property_image/demo_\(image_name)_\(randomNum).jpg")
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        let uploadTask = storageRef.putData(data as Data,metadata: uploadMetadata){(metadata, error) in
            
            if(error != nil){
                print("I receive an error! \(error)")
            }else{
                print("Image Uploaded \(metadata)")
                
                self.firebaseURL = String(describing: metadata!.downloadURL()!)
                print("image url \(String(describing: metadata!.downloadURL()!))")
            }
        }
        
    }
    
   /* func toolBarWithDone(){
        
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        let btnDone = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        btnDone.addTarget(self, action: #selector(self.doneWithKeyboard), for: .touchUpInside)
        btnDone.setTitle("Done", for: .normal)
        btnDone.setTitleColor(UIColor.white, for: .normal)
        btnDone.setTitleColor(UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 178.0/255.0, alpha: 1.0), for: .highlighted)
        
        let btnItemDone = UIBarButtonItem(customView: btnDone)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, btnItemDone], animated: false)
        
        btnItemDone.tintColor = UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        toolbar.barTintColor = UIColor.black
        self.propertyFoundDate.inputAccessoryView = toolbar
        //self.inputAccessoryView = toolbar
       // propertyFoundDate.setPlaceHolderColor(color: UIColor.lightGray)
        
    }*/
    
    
    func addToolBar(){
        
        let toolbar = UIToolbar(frame :CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 80))
        
        let btnDone = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        btnDone.addTarget(self, action: #selector(self.doneWithKeyboard), for: .touchUpInside)
        btnDone.setTitle("Done", for: .normal)
        btnDone.setTitleColor(UIColor.white, for: .normal)
        btnDone.setTitleColor(UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 178.0/255.0, alpha: 1.0), for: .highlighted)
        
        let btnItemDone = UIBarButtonItem(customView: btnDone)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        btnItemDone.tintColor = UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 178.0/255.0, alpha: 1.0)
      //  btnItemDone.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: UIControlState.normal)
        
        let btnPrev = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        btnPrev.addTarget(self, action: #selector(self.previousSelected), for: .touchUpInside)
        btnPrev.setTitle("Prev", for: .normal)
        btnPrev.setTitleColor(UIColor.white, for: .normal)
        btnPrev.setTitleColor(UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 178.0/255.0, alpha: 1.0), for: .highlighted)
        
        let btnItemPrev = UIBarButtonItem(customView: btnPrev)
        
        btnItemPrev.tintColor = UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        
       // btnItemPrev.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: UIControlState.normal)
        //----------
        
        let btnnext = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        btnnext.addTarget(self, action: #selector(self.nextSelected), for: .touchUpInside)
        btnnext.setTitle("Next", for: .normal)
        btnnext.setTitleColor(UIColor.white, for: .normal)
        btnnext.setTitleColor(UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 178.0/255.0, alpha: 1.0), for: .highlighted)
        
        let btnItemNext = UIBarButtonItem(customView: btnnext)
        
        btnItemNext.tintColor = UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        
      //  btnItemNext.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: UIControlState.normal)
        
        //toolbar.setItems([btnItemNext,btnItemPrev,spaceButton, btnItemDone], animated: false)
        toolbar.setItems([btnItemPrev,btnItemNext,spaceButton, btnItemDone], animated: false)
        
        toolbar.barTintColor = UIColor.black
        toolbar.sizeToFit()
        self.propertyNameTextField.inputAccessoryView = toolbar
        self.propertyDescriptionTextField.inputAccessoryView = toolbar
        self.propertyFoundDate.inputAccessoryView = toolbar
    }
    
    @objc func doneWithKeyboard(){
        
       // self.view.endEditing(true)
       // propertyFoundDate.resignFirstResponder()
        if(propertyFoundDate.isFirstResponder){
            if(dateSelected == ""){
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let selectedDate: String = dateFormatter.string(from: dateSelected_)
                propertyFoundDate.text! = selectedDate
                
            }else{
                propertyFoundDate.text! = dateSelected
            }
        }
    }
    
    
    @objc func nextSelected(){
        
        
        if propertyNameTextField.isFirstResponder {
            
            propertyDescriptionTextField.becomeFirstResponder()
            
        }else if propertyDescriptionTextField.isFirstResponder{
            
            propertyFoundDate.becomeFirstResponder()
            
        }else if propertyFoundDate.isFirstResponder{
            addLocationBtn.becomeFirstResponder()
        }
        
    }
    @objc func previousSelected(){
        if addLocationBtn.isFirstResponder{
            
            propertyFoundDate.becomeFirstResponder()

        }else if propertyFoundDate.isFirstResponder {
            
            propertyDescriptionTextField.becomeFirstResponder()
            
        }else if propertyDescriptionTextField.isFirstResponder{
            
            propertyNameTextField.becomeFirstResponder()
            
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
