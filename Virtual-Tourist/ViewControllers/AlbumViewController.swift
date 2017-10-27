//
//  AlbumViewController.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 24/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class AlbumViewController: MyViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var location: Location?
    var count: Int! = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FlickrClient.sharedInstance().getPhotos(lat: location!.latitude, lon: location!.longitude)
        
        setView()
//        setFR()
    }
    
//    func setFR() {
//        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
//        fr.sortDescriptors = [NSSortDescriptor(key: "data", ascending: true)]
//
//        fr.predicate = NSPredicate(format: "Location = %@", argumentArray: [location!])
//
//        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: delegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(count)
        if count == 0 {
            return 21
        }
        return count
//        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCell", for: indexPath) as! FlickrImageCollectionCell
        if count == 0 {
            cell.index = indexPath.row
            cell.location = location
            cell.initiate()
        } else {
            let photo = fetchedResultsController.object(at: indexPath) as! Photo
            cell.flickrImage.image = UIImage(data: photo.data! as Data)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func executeSearch() {
        
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
                count = fc.fetchedObjects?.count
                if let results = fc.fetchedObjects as? [Photo] {
                    print("getting in: \(results)")
                    performUIUpdatesOnMain {
//                        self.mapView.addAnnotations(results)
                    }
                }
                print("getting out")
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
}

extension AlbumViewController {
    
    func setView() {
        
        collectionViewFlowLayout.minimumLineSpacing = 3
        collectionViewFlowLayout.minimumInteritemSpacing = 3
        collectionViewFlowLayout.itemSize = CGSize(width: (view.frame.width/3) - 2, height: view.frame.width/3 - 2)
        
        mapView.delegate = self
        mapView.isZoomEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false
        mapView.addAnnotation(location!)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: location!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
