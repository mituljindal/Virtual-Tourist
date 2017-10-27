//
//  FlickrConvenience.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 28/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    func getPhotos(location: Location, completion: @escaping (_ count: Int) -> (Void)) {
    
        let page: Int
        if let photos = dataArray[location] {
            if(photos.page > photos.lastPage) {
                return
            } else {
                page = photos.page
                dataArray[location] = nil
            }
        } else {
            page = 1
        }
        
        var urlString = API.url + "&api_key=" + API.apiKey + "&lat=\(location.latitude)&lon=\(location.longitude)&format=json&nojsoncallback=1&per_page=21&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        let _ = handleRequest(request: request) { data, error in
            
            func handleError(error: String) {
                performUIUpdatesOnMain {
                    print("error: \(error)\n")
                }
            }
            
            if let error = error {
                handleError(error: error)
            }
            
            guard let data = data else {
                handleError(error: "No data")
                return
            }
            
            let result: [String:AnyObject]!
            
            do {
                result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                handleError(error: "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard (result["stat"] as? String) == "ok" else {
                handleError(error: "Status not ok")
                return
            }
            
            if let a = result["photos"] as? [String: AnyObject] {
                var photos = FlickrPhotos(a)
                photos.page += 1
                self.dataArray[location] = photos
                
                self.getImages(location)
                
//                self.appDelegate.photos = photos.photos
//                self.appDelegate.isData = true
//                NotificationCenter.default.post(name: .updatedPhotos, object: nil)
                performUIUpdatesOnMain {
                    completion(photos.photos.count)
                }
            }
        }
    }
    
    func getImages(_ location: Location) {
        
        guard let photos = self.dataArray[location]?.photos else {
            return
        }
        
        for photo in photos {
            getImage(photo, location)
        }
        
    }
    
    func getImage(_ photo: FPhoto, _ location: Location) {
        
        let url =  URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_m.jpg")
        
        let request = URLRequest(url: url!)
        
        let _ = handleRequest(request: request) { data, error in
            func handleError(error: String) {
                performUIUpdatesOnMain {
                    print("error: \(error)\n")
                }
            }
            
            if let error = error {
                handleError(error: error)
                return
            }
            guard let data = data else {
                handleError(error: "No data")
                return
            }
            
            let _ = Photo(data: data as NSData, location: location, context: self.appDelegate.stack.context)
            
//            let image = UIImage(data: data)
//            performUIUpdatesOnMain {
//                self.activityIndicator.stopAnimating()
//                self.flickrImage.image = image
//            }
        }
    }
}
