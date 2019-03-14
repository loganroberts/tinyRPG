//
//  ActionMenu.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/14/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class ActionMenu: SKNode {
    
    let background = SKSpriteNode(color: .black, size: CGSize(width: 420, height: 420))
    
    let moveButton = SKSpriteNode(color: .darkGray, size: CGSize(width: 160, height: 160))
    let endTurnButton = SKSpriteNode(color: .darkGray, size: CGSize(width: 160, height: 160))
    let tileActionButton = SKSpriteNode(color: .darkGray, size: CGSize(width: 160, height: 160))
    let inventoryButton = SKSpriteNode(color: .darkGray, size: CGSize(width: 160, height: 160))
    
    init(name: String) {
        super.init()
        self.name = name
        
        moveButton.name = "MoveButton"
        moveButton.position = CGPoint(x: -100, y: 100)
        
        endTurnButton.name = "EndTurn"
        endTurnButton.position = CGPoint(x: -100, y: -100)
        
        tileActionButton.name = "TileActoin"
        tileActionButton.position = CGPoint(x: 100, y: 100)
        
        inventoryButton.name = "Inventory"
        inventoryButton.position = CGPoint(x: 100, y: -100)
        
        background.alpha = 0.75
    
        addChild(background)
        addChild(endTurnButton)
        addChild(tileActionButton)
        addChild(moveButton)
        addChild(inventoryButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
