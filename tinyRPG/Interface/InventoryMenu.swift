//
//  InventoryMenu.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/13/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class InventoryMenu: SKNode {
    let background = SKSpriteNode(color: .blue, size: CGSize(width: 600, height: 600))
    
    var owner: Character
    
    init(owner: Character) {
        self.owner = owner
        super.init()
        name = "InventoryMenu"
        background.zPosition = 100
        background.position = CGPoint(x: 0, y: 0)
        
        let weaponX = -150
        var weaponY = 210
        
        for each in owner.inventory.weaponBag {
            let labelBG = SKSpriteNode(color: .black, size: CGSize(width: 250, height: 100))
            labelBG.position = CGPoint(x: weaponX, y: weaponY)
            background.addChild(labelBG)
            
            let weapon = each.value
            labelBG.addChild(SKLabelNode(text: weapon.name))
            weaponY -= 125
            
        }
        
        addChild(background)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
