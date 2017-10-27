//
//  Extensions.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 25/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit
import MapKit

extension Notification.Name {
    static let updatedPhotos = Notification.Name("updatedPhotos")
}

extension MapViewController: UIGestureRecognizerDelegate {
    func setMapView() {
        if !UserDefaults.standard.bool(forKey: "HasLaunchedBefore") {
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
            let x = mapView.visibleMapRect
            
            UserDefaults.standard.set(x.origin.x, forKey: "OriginX")
            UserDefaults.standard.set(x.origin.y, forKey: "OriginY")
            UserDefaults.standard.set(x.size.height, forKey: "Height")
            UserDefaults.standard.set(x.size.width, forKey: "Width")
        } else {
            var x = MKMapRect()
            
            x.origin.x = UserDefaults.standard.double(forKey: "OriginX")
            x.origin.y = UserDefaults.standard.double(forKey: "OriginY")
            x.size.height = UserDefaults.standard.double(forKey: "Height")
            x.size.width = UserDefaults.standard.double(forKey: "Width")
            
            mapView.setVisibleMapRect(x, animated: true)
        }
    }
    
    @objc func didDragMap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            let x = mapView.visibleMapRect
            
            UserDefaults.standard.set(x.origin.x, forKey: "OriginX")
            UserDefaults.standard.set(x.origin.y, forKey: "OriginY")
            UserDefaults.standard.set(x.size.height, forKey: "Height")
            UserDefaults.standard.set(x.size.width, forKey: "Width")
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
