//
//  ViewController.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 24/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: MyViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var barButton: UIBarButtonItem!
    var annotations = [MKPointAnnotation]()
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.isHidden = true
        mapView.delegate = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.addPin))
        self.mapView.addGestureRecognizer(longPress)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
        panGesture.delegate = self
        self.mapView.addGestureRecognizer(panGesture)
        
        setMapView()
    }
    
    @objc func addPin(gesture: UIGestureRecognizer) {
        
        if gesture.state == .ended {
            let point = gesture.location(in: mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "1234"
            annotation.subtitle = "qwsedfrg"
            mapView.addAnnotation(annotation)
            self.annotations.append(annotation)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if flag {
            mapView.removeAnnotation(view.annotation!)
        } else {
            let controller = storyboard?.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
            controller.location = (view.annotation?.coordinate)!
            self.navigationController?.pushViewController(controller, animated: true)
            mapView.deselectAnnotation(view.annotation, animated: true)
        }
    }
    
    @IBAction func editPressed(_ sender: Any) {
        if flag {
            self.barButton.title = "Edit"
        } else {
            self.barButton.title = "Done"
        }
        textView.isHidden = flag
        flag = !flag
    }
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
