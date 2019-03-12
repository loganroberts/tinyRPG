//
//  TopMenu.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/12/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class TopMenu: SKNode {
    
    let background = SKSpriteNode(color: .black, size: CGSize(width: 1125, height: 55))
    let levelLabel = SKLabelNode(text: "Level: 0")
    let healthLabel = SKLabelNode(text: "HP: 0")
   
    override init() {
        super.init()
        self.name = "TopMenu"
        healthLabel.fontSize = 30
        levelLabel.fontColor = .white
        healthLabel.fontColor = .white
        
        levelLabel.position = CGPoint(x: -220, y: -5)
        healthLabel.position = CGPoint(x: 220, y: -5)
        
        background.addChild(levelLabel)
        background.addChild(healthLabel)
        addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
