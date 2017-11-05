//
//  Photo+CoreDataClass.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 05/11/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    
    convenience init(data: NSData, location: Location, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.data = data
            self.location = location
            self.time = NSDate()
        }
        else {
            fatalError("Unable to find Entity name!")
        }
    }
}
