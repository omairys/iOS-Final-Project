//
//  Location+CoreDataProperties.swift
//  Final Project App
//
//  Created by Omairys Uzcátegui on 2021-09-23.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var name: String?
    @NSManaged public var birtday: Date?
    @NSManaged public var photoID: NSNumber?
    @NSManaged public var gender: String?
    @NSManaged public var country: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension Location : Identifiable {

}
