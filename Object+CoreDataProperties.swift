//
//  Object+CoreDataProperties.swift
//  Drink
//
//  Created by Luis Gonzalez on 8/2/21.
//
//

import Foundation
import CoreData


extension Object {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Object> {
        return NSFetchRequest<Object>(entityName: "Object")
    }

    // MANAGE CONTEXT, middle man in saving
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var category: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var instructions: String?
    @NSManaged public var imageLink: String?

}

extension Object : Identifiable {

}
