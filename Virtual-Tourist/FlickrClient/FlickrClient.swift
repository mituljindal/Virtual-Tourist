//
//  FlickrClient.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 25/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

class FlickrClient {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var dataArray = [Location: FlickrPhotos]()
    
    func handleRequest(request: URLRequest, completion: @escaping (_ data: Data?, _ error: String?) -> (Void)) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            func handlerError(error: String) {
                performUIUpdatesOnMain {
                    completion(nil, error)
                }
                return
            }
            
            guard (error == nil) else {
                handlerError(error: "Please check your internet connection")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                return
            }
            
            if (statusCode < 200 && statusCode > 299) {
                handlerError(error: "Your request returned a status code other than 2xx!: \(statusCode)")
                return
            }
            
            guard let data = data else {
                handlerError(error: "No data was returned by the request!")
                return
            }
            performUIUpdatesOnMain {
                completion(data, nil)
            }
        }
        task.resume()
        
        return task
    }
    
    class func sharedInstance() -> FlickrClient {
        struct singleton {
            static var sharedInstance = FlickrClient()
        }
        return singleton.sharedInstance
    }
}
