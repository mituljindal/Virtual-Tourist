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
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>! {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            executeSearch()
        }
    }
    
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
                fatalError("can't be done")
            
            case .update:
                self.mapView.removeAnnotation(location)
                self.mapView.addAnnotation(location)
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
        
        let object = view.annotation as! Location
        
        if flag {
            
            fetchedResultsController.managedObjectContext.delete(object)
            
        } else {
            let controller = storyboard?.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
            let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
            fr.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
            fr.predicate = NSPredicate(format: "location = %@", argumentArray: [object])
            controller.location = object
            controller.fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: delegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
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
    
    func executeSearch() {
        
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

