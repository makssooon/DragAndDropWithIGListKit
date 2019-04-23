//
//  CollectionCellNode.swift
//  DragAndDropWithIGListKit
//
//  Created by Maksym Popovych on 4/23/19.
//  Copyright © 2019 Maksym Popovych. All rights reserved.
//

import AsyncDisplayKit

class CollectionCellNode: ASCellNode {
    
    let textNode = ASTextNode()
    
    let listItem: ListItem
    
    init(listItem: ListItem) {
        self.listItem = listItem
        super.init()
        
        automaticallyManagesSubnodes = true
        borderColor = #colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
        borderWidth = 1
        
        textNode.attributedText = NSAttributedString(
            string: listItem.string,
            attributes: [
                .font : UIFont.boldSystemFont(ofSize: 42),
                .foregroundColor : #colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
            ]
        )
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let centerSpec = ASCenterLayoutSpec(
            horizontalPosition: .center,
            verticalPosition: .center,
            sizingOption: .minimumSize,
            child: textNode
        )
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
            child: centerSpec
        )
    }
}

extension CollectionCellNode: ListBindable {
    func bindViewModel(_ viewModel: Any) {
        guard let listItem = viewModel as? ListItem else {
            return
        }
        
        textNode.attributedText = NSAttributedString(
            string: listItem.string,
            attributes: [
                .font : UIFont.boldSystemFont(ofSize: 42),
                .foregroundColor : #colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
            ]
        )
        
        setNeedsLayout()
    }
}
