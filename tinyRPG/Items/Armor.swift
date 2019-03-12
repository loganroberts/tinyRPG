//
//  Armor.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/12/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import SpriteKit

class Armor {
    enum ArmorSlot: String {
        case head = "Head"
        case body = "Body"
        case hands = "Hands"
        case feet = "Feet"
    }
    
    var name: String
    var slot: ArmorSlot
    var defense: Int
    var speed: Int
    var weight: Int
    var value: Int
    var sellable: Bool
    
    init(data: Dictionary<String, Any>) {
        self.name = data["Name"] as! String
        self.slot = ArmorSlot.init(rawValue: data["ArmorSlot"] as! String)!
        self.defense = data["Defense"] as! Int
        self.speed = data["Speed"] as! Int
        self.weight = data["Weight"] as! Int
        self.value = data["Value"] as! Int
        self.sellable = data["Sellable"] as! Bool
    }
}
