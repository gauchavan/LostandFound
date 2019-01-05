//
//  MapViewController.swift
//  Lost&Found
//
//  Created by gauri chavan on 4/24/18.
//  Copyright © 2018 gauri chavan. All rights reserved.
//

import UIKit
import MapKit

protocol DoneButtonDelegate {
    func doneButtonClicekd(lattitude :CLLocationDegrees,longitiude : CLLocationDegrees)
}

var latitude:CLLocationDegrees = 0
var longitude:CLLocationDegrees = 0

class MapViewController: UIViewController, UISearchBarDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var delegate :DoneButtonDelegate!
    
    @IBAction func mapSearchBtn(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func DoneBtnFunc(_ sender: UIBarButtonItem) {
            self.navigationController?.popViewController(animated: true)
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //ingnoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start{(response, error) in
            
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil{
                print("error")
            }else{
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
            
            
                latitude = (response?.boundingRegion.center.latitude)!
                longitude = (response?.boundingRegion.center.longitude)!
                
                
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                self.mapView.addAnnotation(annotation)
                
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude,longitude)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapView.setRegion(region, animated: true)
                
                
                
            }
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
