//
//  AlbumViewController.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 24/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit
import MapKit

class AlbumViewController: MyViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var location = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FlickrClient.sharedInstance().getPhotos(lat: location.latitude, lon: location.longitude, page: 1)
        
        setMap()
    }
    
    func setMap() {
        mapView.delegate = self
        
        mapView.isZoomEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}