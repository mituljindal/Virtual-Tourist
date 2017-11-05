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
    var flag = true
    
    var selection = [IndexPath: Bool]()
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        self.button.isEnabled = false
        
        fetchedResultsController?.delegate = self
        executeSearch()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlickrCell", for: indexPath) as! FlickrImageCollectionCell
        
        if !data {
            cell.flickrImage.image = nil
            cell.startAnimating()
        } else {
            if (fetchedResultsController.fetchedObjects?.count)! >= indexPath.row {
                cell.stopAnimating()
                
                let photo = fetchedResultsController.object(at: indexPath) as! Photo
                cell.flickrImage.image = UIImage(data: photo.data! as Data)
            } else {
                cell.startAnimating()
            }
        }
        
//        Selected images will remain selected
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
        if selection.count == 0 {
            button.titleLabel?.text = "New Collection"
            flag = true
        } else {
            flag = false
            button.titleLabel?.text = "Remove Selected Pictures"
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        if flag {
            data = false
            button.isEnabled = false
            count = 0
            for object in fetchedResultsController.fetchedObjects! {
                fetchedResultsController.managedObjectContext.delete(object as! NSManagedObject)
            }
            data = false
            collectionView.reloadData()
            getPhotos()
        } else {
            for (index, _) in selection {
                let photo = fetchedResultsController.object(at: index) as! Photo
                fetchedResultsController.managedObjectContext.delete(photo)
                selection[index] = nil
            }
            do {
                try self.delegate.stack.saveContext()
            } catch {
                print("deletion unsuccessful")
            }
            self.executeSearch()
        }
    }
    
    func getPhotos() {
        button.isEnabled = false
        FlickrClient.sharedInstance().getPhotos(location: location!, { count in
            self.count = count
            print("count: \(count)")
            if count == 0 {
                self.noPhotos()
            }
            self.collectionView.reloadData()
        }, {
            self.executeSearch()
        })
    }
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
                count = fc.fetchedObjects?.count
                button.isEnabled = true
                if count != 0 {
                    data = true
                    self.collectionView.reloadData()
                } else {
                    data = false
                    getPhotos()
                }
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
                data = false
                getPhotos()
            }
        }
    }
    
    func noPhotos() {
        self.collectionView.isHidden = true
        self.button.titleLabel?.text = "No Pictures"
        self.button.isEnabled = false
    }
}
