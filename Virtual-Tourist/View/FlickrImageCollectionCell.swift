//
//  FlickrImageCollectionCell.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 25/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

class FlickrImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var flickrImage: UIImageView!
    var index: Int!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func initiate() {
        if !appDelegate.isData {
            NotificationCenter.default.addObserver(self, selector: #selector(getImage), name: .updatedPhotos, object: nil)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            activityIndicator.center = self.flickrImage.center
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            self.flickrImage.addSubview(activityIndicator)
        }
        else {
            getImage()
        }
    }
    
    @objc func getImage() {
        let photo = appDelegate.photos[index]
        let url =  URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_m.jpg")
        
        let request = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            func handleError(error: String) {
                performUIUpdatesOnMain {
                    print("error: \(error)\n")
                }
            }
            
            guard (error == nil) else {
                handleError(error: error as! String)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                return
            }
            
            if (statusCode < 200 && statusCode > 299) {
                handleError(error: "Your request returned a status code other than 2xx!: \(statusCode)")
                return
            }
            
            guard let data = data else {
                handleError(error: "No data was returned by the request!")
                return
            }
            
            let image = UIImage(data: data)
            performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                self.flickrImage.image = image
            }
        }).resume()
    }
}
