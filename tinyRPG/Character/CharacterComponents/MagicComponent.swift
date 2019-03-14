//
//  MagicComponent.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/14/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class MagicComponent: GKComponent {
    var owner: Character
    
    var max = 10
    var current = 10
    var min = 0
    
    init(owner: Character) {
        self.owner = owner
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
