//
//  FlickrImageCollectionCell.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 25/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit
import CoreData

class FlickrImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var flickrImage: UIImageView!
    var index: IndexPath!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var location: Location?
    
    var flag = false
    
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
}
