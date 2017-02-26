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
    
    var gardens: [Garden] = []
    let initialLocation = CLLocation(latitude: 40.7128, longitude: -74.0059)
    let regionRadius: CLLocationDistance = 1000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationsTableView.delegate = self
        locationsTableView.dataSource = self
        mapView.delegate = self
        mapView.mapType  = .standard
        mapView.isZoomEnabled = true
        mapView.showsPointsOfInterest = false
        centerMapOnLocation(location: initialLocation)
        addPin(at: "NYC", lat: 40.7128, long: -74.0059)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gardens.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        return UITableViewCell()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
