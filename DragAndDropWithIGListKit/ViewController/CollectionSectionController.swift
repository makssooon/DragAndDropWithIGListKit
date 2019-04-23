//
//  CollectionSectionController.swift
//  DragAndDropWithIGListKit
//
//  Created by Maksym Popovych on 4/23/19.
//  Copyright © 2019 Maksym Popovych. All rights reserved.
//

import AsyncDisplayKit

class CollectionSectionController: ListBindingSectionController<ListDiffable>, ASSectionController {
    
    override init() {
        super.init()
        dataSource = self
        
        minimumLineSpacing = 35
        inset = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        let model = viewModels[index]
        
        switch model {
        case let listItem as ListItem:
            return {
                let node = CollectionCellNode(listItem: listItem)
                node.style.flexGrow = 1
                node.style.width = ASDimensionMake(200)
                return node
            }
            
        default:
            return {
                return ASCellNode()
            }
        }
    }
    
    func nodeForItem(at index: Int) -> ASCellNode {
        return ASCellNode()
    }
}

extension CollectionSectionController: ListBindingSectionControllerDataSource {
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, viewModelsFor object: Any) -> [ListDiffable] {
        switch object {
        case let listItemsContainer as ListItemsContainer:
            return listItemsContainer.listItems
            
        default:
            return []
        }
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, cellForViewModel viewModel: Any, at index: Int) -> UICollectionViewCell & ListBindable {
        return ASIGListSectionControllerMethods.cellForItem(at: index, sectionController: self) as! UICollectionViewCell & ListBindable
    }
    
    func sectionController(_ sectionController: ListBindingSectionController<ListDiffable>, sizeForViewModel viewModel: Any, at index: Int) -> CGSize {
        return ASIGListSectionControllerMethods.sizeForItem(at: index)
    }
}
