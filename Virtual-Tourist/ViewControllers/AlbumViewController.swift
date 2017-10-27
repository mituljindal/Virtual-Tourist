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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var location: Location?
    var count: Int!
    var data: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        
//        guard let _ = anObject as? Photo else {
//            preconditionFailure("No location changes")
//        }
//        
//        performUIUpdatesOnMain {
//            self.collectionView.reloadData()
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(count)
        return (fetchedResultsController.fetchedObjects?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCell", for: indexPath) as! FlickrImageCollectionCell
        let photo = fetchedResultsController.object(at: indexPath) as! Photo
        
        cell.flickrImage.image = UIImage(data: photo.data! as Data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func executeSearch() {
        
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
                count = fc.fetchedObjects?.count
                if count != 0 {
                    data = true
                } else {
                    data = false
                    FlickrClient.sharedInstance().getPhotos(location: location!) { count in
                    }
                }
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
                data = false
                FlickrClient.sharedInstance().getPhotos(location: location!) { count in
                }
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
