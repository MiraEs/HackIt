//
//  HomeViewController.swift
//  InstaGreen
//
//  Created by Madushani Lekam Wasam Liyanage on 2/26/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationsTableView: UITableView!
    
    var currentGarden: Garden?
    var gardens: [Garden] = []
    let initialLocation = CLLocation(latitude: 40.7128, longitude: -74.0059)
    let regionRadius: CLLocationDistance = 1000
    let apiEndPoint = "https://data.cityofnewyork.us/resource/yes4-7zbb.json"
    let boroDict: [String:String] = ["B": "Brooklyn", "M": "Manhattan", "Q": "Queens", "X":"Bronx"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        locationsTableView.rowHeight = 100
        mapView.delegate = self
        mapView.mapType  = .standard
        mapView.isZoomEnabled = true
        mapView.showsPointsOfInterest = false
        centerMapOnLocation(location: initialLocation)
        addPin(at: "NYC", lat: 40.7128, long: -74.0059)
        self.navigationItem.title = "Instagreen"
        
        getData()
        
    }
    
    func getData() {
        APIRequestManager.manager.getData(endPoint: apiEndPoint) { (data) in
            
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: validData, options: []),
                    let validGarden = jsonData as? [[String:Any]] {
                    
                    self.gardens = Garden.getGardens(from: validGarden)
                    
                    DispatchQueue.main.async {
                        self.locationsTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gardens.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = locationsTableView.dequeueReusableCell(withIdentifier: "gardensCellIdentifier", for: indexPath) as! GardensTableViewCell
        
        let garden = gardens[indexPath.row]
        cell.gardenNameLabel.text = garden.name
        if let boro = boroDict[garden.boro] {
            cell.gardenAddressLabel.text = ("\(garden.address), \(boro)")
        }
        else {
            cell.gardenAddressLabel.text = garden.address
        }
        
        //push this location data to upload screen for photo property
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let garden = gardens[indexPath.row]
        
        getGeoFor(gedLocation: garden, completionHandler: { (cordinates) -> (Void) in
            DispatchQueue.main.async {
                self.addPin(at: garden.name, lat: cordinates.0, long: cordinates.1)
                self.mapView.reloadInputViews()
                self.currentGarden = garden
            }
        })
    }
    
    func getGeoFor(gedLocation: Garden, completionHandler: @escaping ((lat: Double, long: Double)) -> (Void))  {
        let geo = CLGeocoder()
        geo.geocodeAddressString("\(gedLocation.address)") { (placemarkArr, error) in
            guard let placemark = placemarkArr?[0] else { return }
            guard let lat = placemark.location?.coordinate.latitude,
                let long = placemark.location?.coordinate.longitude else { return }
            completionHandler((lat: lat, long: long))
        }
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0,
                                                                  regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addPin(at name: String, lat: Double, long: Double){
        let pinlocation = CLLocation(latitude: lat, longitude: long)
        let pinAnnotation: MKPointAnnotation = MKPointAnnotation()
        pinAnnotation.title = name
        pinAnnotation.coordinate = pinlocation.coordinate
        let oldAnnotations = mapView.annotations
        mapView.removeAnnotations(oldAnnotations)
        mapView.addAnnotation(pinAnnotation)
        centerMapOnLocation(location: pinlocation)
        self.mapView.reloadInputViews()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("clicked annotation")
        let uploadVC = UploadViewController()
        uploadVC.currentGarden = self.currentGarden
        
        if self.tabBarController != nil {
            tabBarController?.selectedIndex = 2
        }
        
    }
    
    
    
}
