//
//  CollectionController.swift
//  DragAndDropWithIGListKit
//
//  Created by Maksym Popovych on 4/23/19.
//  Copyright © 2019 Maksym Popovych. All rights reserved.
//

import AsyncDisplayKit

class CollectionController: ASViewController<ASCollectionNode> {

    let collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var adapter: ListAdapter = {
        let listAdapter = ListAdapter(
            updater: { () -> ListAdapterUpdater in
                let updater = ListAdapterUpdater()
                updater.movesAsDeletesInserts = true
                return updater
            }(),
            viewController: self,
            workingRangeSize: 0
        )
        return listAdapter
    }()
    
    private(set) var itemsContainer: ListItemsContainer
    
    init() {
        itemsContainer = ListItemsContainer(
            listItems: [
                ListItem(string: "Cell 1"),
                ListItem(string: "Cell 2"),
                ListItem(string: "Cell 3"),
                ListItem(string: "Cell 4"),
                ListItem(string: "Cell 5"),
            ],
            id: "listItemsContainer1"
        )
        
        super.init(node: collectionNode)
        
        collectionNode.backgroundColor = .white
        collectionNode.alwaysBounceVertical = true
        collectionNode.clipsToBounds = false
        
        adapter.setASDKCollectionNode(collectionNode)
        adapter.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionNode.view.dragDelegate = self
        collectionNode.view.dropDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [itemsContainer]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CollectionSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension CollectionController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let listItem = itemsContainer.listItems[indexPath.item]
        
        let itemProvider = NSItemProvider(object: listItem)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = listItem
        return [dragItem]
    }
    
//    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//        let params = UIDragPreviewParameters()
//        params.backgroundColor = .clear
//        if let container = collectionView.cellForItem(at: indexPath)?.contentView.subviews.first?.subviews.first {
//            params.visiblePath = UIBezierPath(
//                roundedRect: container.frame,
//                cornerRadius: 10.0
//            )
//        }
//        return params
//    }
}

extension CollectionController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath,
            let collectionViewDragItem = coordinator.items.first,
            let sourceIndexPath = collectionViewDragItem.sourceIndexPath,
            let dragItem = coordinator.items.first?.dragItem,
            let item = dragItem.localObject as? ListItem
            else { return }
        
        switch coordinator.proposal.operation {
        case .copy:
            break
            
        case .move:
            let newItemsContainer = ListItemsContainer(listItems: itemsContainer.listItems, id: itemsContainer.id)
            newItemsContainer.listItems.remove(at: sourceIndexPath.item)
            newItemsContainer.listItems.insert(item, at: destinationIndexPath.item)
            itemsContainer = newItemsContainer
            
            adapter.performUpdates(animated: true, completion: nil)
            coordinator.drop(dragItem, toItemAt: destinationIndexPath)
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if let _ = session.localDragSession {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//        let params = UIDragPreviewParameters()
//        params.backgroundColor = .clear
//        if let container = collectionView.cellForItem(at: indexPath)?.contentView.subviews.first?.subviews.first {
//            params.visiblePath = UIBezierPath(
//                roundedRect: container.frame,
//                cornerRadius: 10.0
//            )
//        }
//        return params
//    }
}
