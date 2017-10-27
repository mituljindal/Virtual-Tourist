//
//  ViewController.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 24/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: MyViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var barButton: UIBarButtonItem!
    var annotations = [NSManagedObject]()
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
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: delegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        setMapView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let location = anObject as? Location else {
            preconditionFailure("No location changes")
        }
        
        performUIUpdatesOnMain {
            
            switch type {
            case .insert:
                self.mapView.addAnnotation(location)
                
            case .delete:
                self.mapView.removeAnnotation(location)
            
            case .move:
                self.mapView.removeAnnotation(location)
                self.mapView.addAnnotation(location)
            
            case .update:
                fatalError("can't be done")
            }
        }
    }
    
    @objc func addPin(gesture: UIGestureRecognizer) {
        
        if gesture.state == .ended {
            let point = gesture.location(in: mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.save(annotation.coordinate)
        }
    }
    
    func save(_ location: CLLocationCoordinate2D) {

        let _ = Location(latitude: location.latitude, longitude: location.longitude, context: fetchedResultsController.managedObjectContext)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if flag {
            
            let object = view.annotation as! Location
            fetchedResultsController.managedObjectContext.delete(object)
            
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
    
    override func executeSearch() {
        
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
                if let results = fc.fetchedObjects as? [Location] {
                    
                    performUIUpdatesOnMain {
                        self.mapView.addAnnotations(results)
                    }
                }
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
}

