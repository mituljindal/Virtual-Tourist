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
    @IBOutlet weak var button: UIButton!
    
    var location: Location?
    var count: Int!
    var data: Bool!
    
    var selection = [IndexPath: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.titleEdgeInsets.left = 1
        button.titleEdgeInsets.right = 1
        button.titleLabel?.textAlignment = .center
        setView()
        self.button.isEnabled = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        button.isEnabled = true
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCell", for: indexPath) as! FlickrImageCollectionCell
        
        cell.location = location
        cell.index = indexPath
        if data {
            let photo = fetchedResultsController.object(at: indexPath) as! Photo
            
            cell.flickrImage.image = UIImage(data: photo.data! as Data)
        } else  {
            cell.initiate()
        }
        if let _ = selection[indexPath] {
            cell.layer.opacity = 0.5
        } else {
            cell.layer.opacity = 1
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if let _ = selection[indexPath] {
            cell?.layer.opacity = 1
            selection[indexPath] = nil
        } else {
            cell?.layer.opacity = 0.5
            selection[indexPath] = true
        }
        if selection.count > 0 {
            button.titleLabel?.text = "Remove Selected Pictures"
        } else {
            button.titleLabel?.text = "New Collection"
        }
        print(selection.count)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        if button.titleLabel?.text == "New Collection" {
            data = false
            
            count = 0
            for object in fetchedResultsController.fetchedObjects! {
                fetchedResultsController.managedObjectContext.delete(object as! NSManagedObject)
            }
            data = false
            collectionView.reloadData()
            FlickrClient.sharedInstance().getPhotos(location: location!, { count in
                self.count = count
                self.collectionView.reloadData()
                }, { count in
            })
        }
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
                    FlickrClient.sharedInstance().getPhotos(location: location!, { count in
                        self.count = count
                        self.collectionView.reloadData()
                        self.button.isEnabled = true
                        }, { count in
                    })
                }
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
                data = false
                FlickrClient.sharedInstance().getPhotos(location: location!, { count in
                    self.count = count
                    self.collectionView.reloadData()
                    self.button.isEnabled = true
                    }, { count in
                })
            }
        }
    }
}
