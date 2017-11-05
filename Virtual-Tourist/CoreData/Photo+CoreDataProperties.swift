//
//  Photo+CoreDataProperties.swift
//  Virtual-Tourist
//
//  Created by mitul jindal on 05/11/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var data: NSData?
    @NSManaged public var time: NSDate?
    @NSManaged public var location: Location?

}
