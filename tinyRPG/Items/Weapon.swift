//
//  Weapon.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/12/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import SpriteKit

class Weapon {
    enum WeaponType: String {
        case melee = "Melee"
        case ranged = "Ranged"
        case magic = "Magic"
    }
    
    var name: String
    var weaponType: WeaponType
    var accuracy: Int
    var damage: Int
    var weight: Int
    var value: Int
    var sellable: Bool
    
    init(data: Dictionary<String, Any>) {
        self.name = data["Name"] as! String
        self.accuracy = data["Accuracy"] as! Int
        self.damage = data["Damage"] as! Int
        self.weight = data["Weight"] as! Int
        self.value = data["Value"] as! Int
        self.sellable = data["Sellable"] as! Bool
        self.weaponType = WeaponType.init(rawValue: data["WeaponType"] as! String)!
    }
}
