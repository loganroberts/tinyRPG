//
//  InventoryComponent.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/12/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class InventoryComponent: GKComponent {
    var owner: Character
    
    var weaponBag: [String: Weapon] = [:]
    var armorBag: [String: Armor] = [:]
    
    var weaponSlot: Weapon? = nil
    
    var headSlot: Armor? = nil
    var bodySlot: Armor? = nil
    var feetSlot: Armor? = nil
    var handsSlot: Armor? = nil
    
    var gold = 0
    var wood = 0
    var stone = 0
    var food = 0
    
    init(owner: Character) {
        self.owner = owner
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addWeapon(weapon: Weapon) {
        guard weaponBag[weapon.name] == nil else {
            print("You have one of those already!")
            return
        }
        weaponBag[weapon.name] = weapon
    }
    
    func removeWeapon(weapon: Weapon) {
        guard weapon.sellable == true else {
            print("You can't get rid of that!")
            return
        }
        weaponBag[weapon.name] = nil
    }
    
    func addArmor(armor: Armor) {
        guard armorBag[armor.name] == nil else {
            print("You have one of those already!")
            return
        }
        armorBag[armor.name] = armor
    }
    
    func removeArmor(armor: Armor) {
        guard armor.sellable == true else {
            print("You can't get rid of that!")
            return
        }
        armorBag[armor.name] = nil
    }
    
    func canAffordArmor(armor: Armor) -> Bool {
        guard gold >= armor.value else {
            return false
        }
        return true
    }
    
    func canAffordWeapon(weapon: Weapon) -> Bool {
        guard gold >= weapon.value else {
            return false
        }
        return true
    }
    
    func equipWeapon(weapon: Weapon) {
        weaponSlot = weaponBag[weapon.name]
    }
    
    func deEquipWeapon(weapon: Weapon) {
        weaponSlot = nil
    }
    
    func equipArmor(armor: Armor) {
        switch armor.slot {
        case .body:
            bodySlot = armorBag[armor.name]
        case .head:
            headSlot = armorBag[armor.name]
        case .feet:
            feetSlot = armorBag[armor.name]
        case .hands:
            handsSlot = armorBag[armor.name]
        }
    }
    
    func deEquipArmor(armor: Armor) {
        switch armor.slot {
        case .body:
            bodySlot = nil
        case .head:
            headSlot = nil
        case .feet:
            feetSlot = nil
        case .hands:
            handsSlot = nil
        }
    }
    
}
