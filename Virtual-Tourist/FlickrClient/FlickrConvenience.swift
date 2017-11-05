//
//  FlickrConvenience.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 28/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    func getPhotos(location: Location, _ completion: @escaping (_ count: Int) -> (Void), _ completion2: @escaping (_ count: Data) -> (Void)) {
    
        let page: Int
        if let photos = dataArray[location] {
            if(photos.page > photos.lastPage) {
                print(1)
                return
            } else {
                print(2)
                page = photos.page
                dataArray[location] = nil
            }
        } else {
            print(3)
            page = 1
        }
        
        var urlString = API.url + "&api_key=" + API.apiKey + "&lat=\(location.latitude)&lon=\(location.longitude)&format=json&nojsoncallback=1&per_page=21&page=\(page)"
        print(urlString)
        
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
                photos.page = page + 1
                self.dataArray[location] = photos
                
                print("dataset received")
                performUIUpdatesOnMain {
                    print("sending count to main")
                    completion(photos.photos.count)
                }
                
                print("Getting images")
                self.getImages(location, completion2)
            }
        }
    }
    
    func getImages(_ location: Location, _ completion2: @escaping (_ count: Data) -> (Void)) {

        guard let photos = self.dataArray[location]?.photos else {
            return
        }

        var i = 0
        for photo in photos {
            print("getting \(i)")
            i += 1
            getImage(photo, location, completion2)
        }

    }
    
    func getImage(_ photo: FPhoto, _ location: Location, _ completion: @escaping (_ completed: Data) -> (Void)) {
        
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
            do {
                try self.appDelegate.stack.saveContext()
            } catch {
                print("Save failed")
            }
            
            performUIUpdatesOnMain {
                completion(data)
            }
        }
    }
}
