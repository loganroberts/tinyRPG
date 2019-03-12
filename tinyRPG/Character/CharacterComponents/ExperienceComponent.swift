//
//  ExperienceComponent.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/12/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import GameplayKit

class ExperienceSystem: GKComponent {
    var owner: Character
    var killCount = 0
    
    var level = 1
    var baseXP = 10
    var total = 0.0
    
    var netXP: Double {
        let _a = xpNeeded - total
        let _b = (_a*100).rounded()/100
        return _b
    }
    
    var dropXP: Double {
        let _xp = Double(baseXP * level) / 7
        return _xp
    }
    
    var xpNeeded: Double {
        let _a: Double = Double(nextLevel)
        let _b: Double = pow(_a, 3.0)
        let _c: Double = _b * 4.0
        return _c / 7
    }
    
    var nextLevel: Int {
        return level + 1
    }
    
    init(owner: Character) {
        self.owner = owner
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func combatComplete(xpDrop: Double) {
        total += xpDrop
        killCount += 1
        levelUpCheck()
    }
    
    func levelUpCheck() {
        guard total >= xpNeeded else {
            print("You need \(netXP) XP to get to level \(nextLevel)")
            return
        }
        level += 1
        print("You leveled up! You are now level \(level)!!")
        print("You need \(xpNeeded) XP to get to level \(nextLevel)")
    }
    
}
