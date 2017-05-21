//
//  Grave+CoreDataProperties.swift
//  PoznanGraves
//
//  Created by Robert Ignasiak on 21.05.2017.
//  Copyright © 2017 Torianin. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Grave {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grave> {
        return NSFetchRequest<Grave>(entityName: "Grave");
    }

    @NSManaged public var birthDate: String?
    @NSManaged public var deathDate: String?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var paid: NSNumber?
    @NSManaged public var place: String?
    @NSManaged public var printName: String?
    @NSManaged public var printSurname: String?
    @NSManaged public var quarter: String?
    @NSManaged public var row: String?

}
