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
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startAnimating() {
        activityIndicator.center = self.flickrImage.center
        self.activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.flickrImage.addSubview(activityIndicator)
    }
    
    func stopAnimating() {
        self.activityIndicator.stopAnimating()
    }
}
