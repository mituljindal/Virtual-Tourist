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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(count)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCell", for: indexPath) as! FlickrImageCollectionCell
        
        cell.location = location
        cell.index = indexPath
        if data {
            let photo = fetchedResultsController.object(at: indexPath) as! Photo
            
            cell.flickrImage.image = UIImage(data: photo.data! as Data)
        } else  {
            cell.initiate()
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
                if count != 0 {
                    data = true
                } else {
                    data = false
                    FlickrClient.sharedInstance().getPhotos(location: location!) { count in
                        self.count = count
                        self.collectionView.reloadData()
                    }
                }
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
                data = false
                FlickrClient.sharedInstance().getPhotos(location: location!) { count in
                    self.count = count
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
