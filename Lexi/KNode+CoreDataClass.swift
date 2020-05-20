//
//  KNode+CoreDataClass.swift
//  kNode
//
//  Created by Kaunteya Suryawanshi on 21/07/19.
//  Copyright © 2019 Kaunteya Suryawanshi. All rights reserved.
//
//

import Foundation
import CoreData

var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Document")
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [description]

    container.loadPersistentStores { _, error in
        if let error = error {
            fatalError("KK Error: \(error)")
        }
    }
    return container
}()

var privateM: NSManagedObjectContext = {
    let privateM = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    privateM.parent = persistentContainer.viewContext
    return privateM
}()

enum KeyOrValue { case key, value }

@objc(KNode)
public class KNode: NSManagedObject {
    enum `Type`: Int { case null, num, bool, string, array, dict }
    enum Key { case root, dict(String), array(Int) }

    convenience init?(string: String) throws {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        try self.init(data: data)
    }

    convenience init?(data: Data) throws {
        let obj = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
        self.init(serialisedJSON: obj, key: nil)
    }

    init?(serialisedJSON any: Any, key: String?) {
        let entity = NSEntityDescription.entity(forEntityName: "KNode", in: privateM)!
        super.init(entity: entity, insertInto: privateM)

        privateM.performAndWait {
            self.key = key
            switch any {
            case let dict as NSDictionary:
                let sortedKeys = (dict.allKeys as! [String]).sorted()
                for key in sortedKeys {
                    let node = KNode(serialisedJSON: dict[key]!, key: key)!
                    addToChildren(node)
                }
                self.type__ = Int16(Type.dict.rawValue)

            case let arr as NSArray:
                for a in arr {
                    addToChildren(KNode(serialisedJSON: a, key: nil)!)
                }
                self.type__ = Int16(Type.array.rawValue)

            case is NSNull:
                self.type__ = Int16(Type.null.rawValue)

            case let num as NSNumber:
                if num.isBool {
                    self.boolValue = num == 1
                    self.type__ = Int16(Type.bool.rawValue)
                } else {
                    self.stringValue = "\(num)"
                    self.type__ = Int16(Type.num.rawValue)
                }

            case let str as String:
                self.stringValue = str
                self.type__ = Int16(Type.string.rawValue)

            default:
                fatalError("Invalid type \(any)")
            }
        }
    }

    var type: Type {
        return Type(rawValue: Int(type__))!
    }

    var isCollection: Bool {
        return type == .array || type == .dict
    }

    /// Any value except array and dictionary is primitive
    var isPrimitiveValue: Bool {
        return !isCollection
    }

    var isEmptyCollection: Bool {
        return children!.count == 0
    }

    var isRoot: Bool {
        return parent == nil
    }

    var keyOrIndex: Key {
        if isRoot { return .root }
        if let key = key { return .dict(key)}
        if let index = indexInParent {
            return .array(index)
        }
        fatalError()
    }

    var openBracket: String {
        switch type {
        case .array: return "["
        case .dict: return "{"
        default: fatalError("Must not be called for kNodes that do not contain collection")
        }
    }

    var closeBracket: String {
        switch type {
        case .array: return "]"
        case .dict: return "}"
        default: fatalError("Must not be called for kNodes that do not contain collection")
        }
    }

    func keyString(literalise: Bool, inQuotes: Bool) -> String {
        if var str = key {
            if inQuotes { str = #""\#(str as String)""#}
            if literalise { str = str.literalized }
            return str
        }
        if let parent = parent {
            let index = parent.children!.index(of: self)
            return "\(index)"
        } else {
            switch type {
            case .array: return "Array"
            case .dict: return "Object"
            default: return "ROOT"
            }
        }
    }

    func valueString(literalise: Bool, inQuotes: Bool) -> String {
        switch type {
        case .null: return "null"
        case .bool: return boolValue ? "true" : "false"
        case .num: return stringValue ?? ""
        case .string:
            var str = stringValue ?? ""
            if literalise { str = str.literalized }
            if inQuotes { str = #""\#(str as String)""#}
            return str
        case .array, .dict:
            return "\(openBracket)\(children!.count)\(closeBracket)"
        }
    }

    func stringRepresentation(type: KeyOrValue, literalise: Bool, inQuotes: Bool) -> String {
        switch type {
        case .key: return keyString(literalise: literalise, inQuotes: inQuotes)
        case .value: return valueString(literalise: literalise, inQuotes: inQuotes)
        }
    }

    var pathFromRoot: [KNode] {
        var list = [KNode]()
        var i: KNode? = self
        while i != nil {
            list.append(i!)
            i = i!.parent
        }
        return list.reversed()
    }

    var indexInParent: Int? {
        return parent?.children?.index(of: self)
    }
}

extension NSNumber {
    /// Checks if NSNumber is orginally a bollean as JSONSerializer converts Bool to NSNumber
    var isBool: Bool {
        // https://stackoverflow.com/a/30223989/1311902
        let boolID = CFBooleanGetTypeID() // the type ID of CFBoolean
        let numID = CFGetTypeID(self) // the type ID of num
        return numID == boolID
    }
}

public enum JSONTextFormatter: Equatable {
    case minified, spaceCount(Int)

    var space: String {
        if case JSONTextFormatter.minified = self { return "" }
        return " "
    }

    var nL: String {
        if case JSONTextFormatter.minified = self { return "" }
        return "\n"
    }

    func indent(_ level: Int) -> String {
        switch self {
        case .minified: return ""
        case .spaceCount(let count):
            return String(repeating: space, count: level * count)
        }
    }
}

extension KNode {
    /// Formats the KNode based tree to text format
    ///
    /// - Parameters:
    ///   - f: Formatter that decides the indentation and white spacing
    ///   - level: Used internally to know the depth of recursion
    /// - Returns: Formatted text based on formatting
    func toText(formatting f: JSONTextFormatter, indentation level: Int = 0) -> String {
        let indent = f.indent(level)
        let keyColon = key.map { #""\#($0.literalized)":\#(f.space)"# } ?? ""

        if isPrimitiveValue {
            return indent + keyColon + valueString(literalise: true, inQuotes: true)
        }

        let joinedValues = children?
            .map { ($0 as! KNode).toText(formatting: f, indentation: level + 1) }
            .joined(separator: ",\(f.nL)") ?? "||"

        return indent
            + keyColon
            + openBracket
            + (isEmptyCollection ? "" : "\(f.nL)\(joinedValues)\(f.nL)\(indent)")
            + closeBracket
    }

    public override var debugDescription: String {
        return keyString(literalise: false, inQuotes: false)
            + ":"
            + valueString(literalise: false, inQuotes: false)
    }
}
