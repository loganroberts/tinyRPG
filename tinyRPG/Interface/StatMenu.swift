//
//  StatMenu.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/14/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class StatMenu: SKNode {
    
    //setup stat menu things
    let background = SKSpriteNode(color: .black, size: CGSize(width: 620, height: 150))
    
    var food = 0
    var foodDisplay: SKLabelNode
   
    var wood = 0
    var woodDisplay: SKLabelNode
    
    var stone = 0
    var stoneDisplay: SKLabelNode
    
    var gold = 0
    var goldDisplay: SKLabelNode
    
    var currentHealth = 100
    var maxHealth = 100
    var healthBar: SKSpriteNode
    var healthBackground: SKSpriteNode
    
    var currentMagic = 100
    var maxMagic = 100
    var magicBar: SKSpriteNode
    var magicBackground: SKSpriteNode
    
    init(name: String) {
        self.foodDisplay = SKLabelNode(text: "Food: \(food)")
        self.woodDisplay = SKLabelNode(text: "Wood: \(wood)")
        self.stoneDisplay = SKLabelNode(text: "Stone: \(stone)")
        self.goldDisplay = SKLabelNode(text: "Gold: \(gold)")
        
        //set bars and backgrounds to feed from current/max stats
        self.healthBar = SKSpriteNode(color: .red, size: CGSize(width: currentHealth, height: 20))
        self.healthBackground = SKSpriteNode(color: .darkGray, size: CGSize(width: maxHealth, height: 16))
        self.magicBar = SKSpriteNode(color: .blue, size: CGSize(width: currentMagic, height: 20))
        self.magicBackground = SKSpriteNode(color: .darkGray, size: CGSize(width: maxMagic, height: 16))
        
        super.init()
        self.name = name
        
        //positioning
        foodDisplay.position = CGPoint(x: -230, y: -50)
        woodDisplay.position = CGPoint(x: -80, y: -50)
        stoneDisplay.position = CGPoint(x: 80, y: -50)
        goldDisplay.position = CGPoint(x: 220, y: -50)
        
        //anchorpoint changes to allow for filling, depleting
        healthBar.position = CGPoint(x: -280, y: 10)
        healthBar.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        healthBackground.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        healthBackground.position = CGPoint(x: -280, y: 10)
        healthBackground.alpha = 0.45
        
        magicBar.position = CGPoint(x: 275, y: 10)
        magicBar.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        magicBackground.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        magicBackground.position = CGPoint(x: 275, y: 10)
        magicBackground.alpha = 0.45
        
        addChild(background)
        
        addChild(healthBackground)
        addChild(healthBar)
        addChild(magicBackground)
        addChild(magicBar)
        
        
        addChild(foodDisplay)
        addChild(woodDisplay)
        addChild(stoneDisplay)
        addChild(goldDisplay)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Called during update loop and changes values based on new info
    func update(character: Character) {
        gold = character.inventory.gold
        food = character.inventory.food
        wood = character.inventory.wood
        stone = character.inventory.stone
        
        foodDisplay.text = "Food: \(food)"
        goldDisplay.text = "Gold: \(gold)"
        woodDisplay.text = "Wood: \(wood)"
        stoneDisplay.text = "Stone: \(stone)"
        
        maxHealth = character.health.max
        currentHealth = character.health.current
        currentMagic = character.magic.current
        
        maxMagic = character.magic.max
        healthBackground.size = CGSize(width: maxHealth, height: 16)
        healthBar.size = CGSize(width: currentHealth, height: 20)
        magicBackground.size = CGSize(width: maxMagic, height: 16)
        magicBar.size = CGSize(width: currentMagic, height: 20)
    }
}
