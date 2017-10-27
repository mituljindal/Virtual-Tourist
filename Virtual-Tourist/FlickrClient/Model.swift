//
//  Model.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 25/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import Foundation

struct FPhoto {
    var farm = Int()
    var id = String()
    var secret = String()
    var server = String()
    var owner = String()
    var isPublic = Bool()
    
    init(_ photo: [String: AnyObject]) {
        self.farm = photo["farm"] as? Int ?? 0
        self.id = photo["id"] as? String ?? ""
        self.secret = photo["secret"] as? String ?? ""
        self.owner = photo["owner"] as? String ?? ""
        self.isPublic = ((photo["ispublic"] as? Int) == 1)
        self.server = photo["server"] as? String ?? ""
    }
}

struct FlickrPhotos {
    var page = 1
    var lastPage = 2
    var photos = [FPhoto]()
    
    init(_ dict: [String: AnyObject]) {
        self.lastPage = dict["pages"] as? Int ?? 2
        guard let arr = dict["photo"] as? [[String: AnyObject]] else { return }
        for a in arr {
            self.photos.append(FPhoto(a))
        }
    }
}
