//
//  FlickrImageCollectionCell.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 25/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit
import CoreData

class FlickrImageCollectionCell: UICollectionViewCell, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var flickrImage: UIImageView!
    
    var index: IndexPath!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var delegate = UIApplication.shared.delegate as! AppDelegate
    
    var location: Location!
    
    var flickr = FlickrClient.sharedInstance()
    
    var flag = false
    
    var savedPhoto: Photo!
    
    func startAnimating() {
        self.activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.flickrImage.center
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.flickrImage.addSubview(activityIndicator)
    }
    
    func stopAnimating() {
        self.activityIndicator.stopAnimating()
    }
    
    func initiate() {
        print("\(flag): flag for indexpath \(index.row)")
        if flag {
            print("returning \(index.row)")
            return
        } else {
            flag = true
        }
        startAnimating()
        if nil != flickr.dataArray[location] {
            getImage()
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(getImage), name: .updatedPhotos, object: nil)
        }
    }
    
    @objc func getImage() {
        print("geting \(index.row)")
        if let photo = flickr.dataArray[location] {
            flickr.getImage(photo.photos[index.row], location) { data in
                
                let _ = Photo(data: data as NSData, location: self.location, context: self.delegate.stack.context)
                let image = UIImage(data: data)
                performUIUpdatesOnMain {
                    self.flickrImage.image = image
                    self.stopAnimating()
                }
                do {
                    try self.delegate.stack.saveContext()
                } catch {
                    print("Save failed")
                }
            }
        }
    }
    
    func delete() {
        
    }
}
