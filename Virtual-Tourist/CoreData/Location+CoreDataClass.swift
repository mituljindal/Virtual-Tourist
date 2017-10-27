//
//  Location+CoreDataClass.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 26/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//
//

import Foundation
import MapKit
import CoreData

@objc(Location)
public class Location: NSManagedObject {

    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Location", in: context) {
            self.init(entity: ent, insertInto: context)
            self.latitude = latitude
            self.longitude = longitude
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}

extension Location: MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
