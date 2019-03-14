//
//  SpriteComponent.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/8/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    let node: SKSpriteNode
    
    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        super.init()
        
        node.position = CGPoint(x: 0, y: 0)
        node.scale(to: CGSize(width: 100, height: 100))
        node.zPosition = 1
        node.name = "PlayerSprite"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //update func goes here
    }
}
