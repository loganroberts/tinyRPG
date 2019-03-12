//
//  Menu.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/12/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class BottomMenu: SKNode {
    let background = SKSpriteNode(color: .lightGray, size: CGSize(width: 1125, height: 170))
    
    let button1 = SKSpriteNode(color: .black, size: CGSize(width: 130, height: 130))
    let button2 = SKSpriteNode(color: .black, size: CGSize(width: 130, height: 130))
    let button3 = SKSpriteNode(color: .black, size: CGSize(width: 130, height: 130))
    let button4 = SKSpriteNode(color: .black, size: CGSize(width: 130, height: 130))
    
    override init() {
        
        button1.position = CGPoint(x: -220, y: 0)
        button1.addChild(SKLabelNode(text: "Center"))
        button1.name = "button1"
        
        button2.position = CGPoint(x: -70, y: 0)
        button2.name = "button2"
        
        button3.position = CGPoint(x: 75, y: 0)
        button3.name = "button3"
        
        button4.position = CGPoint(x: 220, y: 0)
        button4.addChild(SKLabelNode(text: "End Turn"))
        button4.name = "button4"
        
        super.init()
        
        background.addChild(button1)
        background.addChild(button2)
        background.addChild(button3)
        background.addChild(button4)
        addChild(background)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
