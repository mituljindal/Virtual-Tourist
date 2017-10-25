//
//  FlickrClient.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 25/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

class FlickrClient {
    
    var page = 1
    var lastPage = 2
    
    func getPhotos(lat: Double, lon: Double) {
        
        if(self.page > self.lastPage) {
            return
        }
        
        var urlString = API.url + "&api_key=" + API.apiKey + "&lat=\(lat)&lon=\(lon)&format=json&nojsoncallback=1&per_page=21&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
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
            
            do {
                guard let result = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                    handleError(error: "couldn't parse data")
                    return
                }
                guard (result["stat"] as? String) == "ok" else {
                    handleError(error: "Status not ok")
                    return
                }
                var photos: FlickrPhotos
                if let a = result["photos"] as? [String: AnyObject] {
                    photos = FlickrPhotos(a)
                    self.lastPage = photos.lastPage
                    self.page += 1
                }
            }
            catch {
                handleError(error: "couldn't parse data")
                return
            }
        }
        task.resume()
    }
    
    class func sharedInstance() -> FlickrClient {
        struct singleton {
            static var sharedInstance = FlickrClient()
        }
        return singleton.sharedInstance
    }
}
