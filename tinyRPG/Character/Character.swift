//
//  Character.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/7/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit


class Character: GKEntity {
    
    //add conveienceProperty for world
    var worldMap: MapGen
    //Visual image of the player. very basic
    let sprite: SpriteComponent
    //movement functions and data for the player
    let movement: MovementComponent
    //experience system for leveling
    lazy var experience = ExperienceSystem(owner: self)
    // health system for damage
    lazy var health = HealthComponent(owner: self)
    //magic system for spells
    lazy var magic = MagicComponent(owner: self)
    //inventory for items and weapons
    lazy var inventory = InventoryComponent(owner: self)
    
    init(texture: SKTexture, map: MapGen) {
        self.worldMap = map
        self.sprite = SpriteComponent(texture: texture)
        self.movement = MovementComponent(map: worldMap)
        super.init()
        
        addComponent(magic)
        addComponent(health)
        addComponent(experience)
        addComponent(movement)
        addComponent(sprite)
        addComponent(inventory)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //update func goes here
    }
}
