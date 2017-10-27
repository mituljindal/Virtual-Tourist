//
//  Photo+CoreDataClass.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 26/10/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {

    convenience init(data: NSData, context: NSManagedObjectContext) {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.data = data
        }
        else {
            fatalError("Unable to find Entity name!")
        }
    }
}
