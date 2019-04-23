//
//  ListItem.swift
//  DragAndDropWithIGListKit
//
//  Created by Maksym Popovych on 4/23/19.
//  Copyright © 2019 Maksym Popovych. All rights reserved.
//

import AsyncDisplayKit

class ListItemsContainer: ListDiffable, Equatable {
    static func == (lhs: ListItemsContainer, rhs: ListItemsContainer) -> Bool {
        return lhs.listItems == rhs.listItems && lhs.id == rhs.id
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let listItemsContainer = object as? ListItemsContainer else {
            return false
        }
        
        return id == listItemsContainer.id
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    var listItems: [ListItem]
    let id: String
    
    init(listItems: [ListItem], id: String) {
        self.listItems = listItems
        self.id = id
    }
}

class ListItem: NSObject, ListDiffable {
    static func == (lhs: ListItem, rhs: ListItem) -> Bool {
        return lhs.string == rhs.string
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return string == (object as? ListItem)?.string
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return string as NSObjectProtocol
    }
    
    let string: String
    
    init(string: String) {
        self.string = string
    }
}

extension ListItem: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return ["itemTypeIdentifier"]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil
    }
}
