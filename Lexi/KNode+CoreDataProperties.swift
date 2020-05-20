//
//  KNode+CoreDataProperties.swift
//  Lexi
//
//  Created by Kaunteya Suryawanshi on 30/07/19.
//  Copyright © 2019 Kaunteya Suryawanshi. All rights reserved.
//
//
//swiftlint:disable all
import Foundation
import CoreData


extension KNode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KNode> {
        return NSFetchRequest<KNode>(entityName: "KNode")
    }

    @NSManaged public var boolValue: Bool
    @NSManaged public var key: String?
    @NSManaged public var stringValue: String?
    @NSManaged public var type__: Int16
    @NSManaged public var children: NSOrderedSet?
    @NSManaged public var parent: KNode?

}

// MARK: Generated accessors for children
extension KNode {

    @objc(insertObject:inChildrenAtIndex:)
    @NSManaged public func insertIntoChildren(_ value: KNode, at idx: Int)

    @objc(removeObjectFromChildrenAtIndex:)
    @NSManaged public func removeFromChildren(at idx: Int)

    @objc(insertChildren:atIndexes:)
    @NSManaged public func insertIntoChildren(_ values: [KNode], at indexes: NSIndexSet)

    @objc(removeChildrenAtIndexes:)
    @NSManaged public func removeFromChildren(at indexes: NSIndexSet)

    @objc(replaceObjectInChildrenAtIndex:withObject:)
    @NSManaged public func replaceChildren(at idx: Int, with value: KNode)

    @objc(replaceChildrenAtIndexes:withChildren:)
    @NSManaged public func replaceChildren(at indexes: NSIndexSet, with values: [KNode])

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: KNode)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: KNode)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSOrderedSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSOrderedSet)

}
//swiftlint:enable all
