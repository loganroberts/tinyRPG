//
//  StateMachine.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/12/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import GameplayKit

class PlayerTurn: GKState {
    //gets the scene the state is attached to
    let game: GameScene
    let player: Character
    
    init(game: GameScene, player: Character) {
        self.game = game
        self.player = player
    }
    
    override func didEnter(from previousState: GKState?) {
        //reset player movepoints after ending a turn
        player.movement.movementPoints = player.movement.maxMovementPoints
        let moves = player.movement.getRange(from: player.movement.currentLocation)
        player.movement.highlightMoves(moves: moves)
        game.addChild(player.movement.movesMap)
    }
}

class GameTurn: GKState {
    
}
