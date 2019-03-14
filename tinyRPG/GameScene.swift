//
//  GameScene.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/7/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Basic Scene setup
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var cam: SKCameraNode?
    
    // min size = C:64 R: 64
    let map = MapGen(columns: 64, rows: 64)

    var previousCameraPoint = CGPoint.zero
    
    let panGesture = UIPanGestureRecognizer()
    
    var gameState: GKStateMachine!
    
    let gameData = getDefaults(name: "GameData")
    //Helper character for testing. DO NOT REFERENCE
    lazy var character = Character(texture: SKTexture(imageNamed: "hero"), map: map)
    
    let statMenu = StatMenu(name: "Stats")
    let actionMenu = ActionMenu(name: "Actions")
    
    override func sceneDidLoad() {
        //setup game state
        gameState = GKStateMachine(states: [PlayerTurn(game: self, player: character), GameTurn()])
        gameState.enter(PlayerTurn.self)
        
        entities.append(character)
        
        addChild(map.tileMap)
        character.sprite.node.zPosition = 999
        addChild(character.sprite.node)
        
    }
    
    //Sets up gestures and camera in scene
    override func didMove(to view: SKView) {
        //pan around the map
        panGesture.addTarget(self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGesture)
      
      
        //setup camera
        cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam!)
        
        //menus
        statMenu.position = CGPoint(x: 0, y: 620)
        cam?.addChild(statMenu)
        
        actionMenu.zPosition = 1000
        actionMenu.isHidden = true
    
        cam?.addChild(actionMenu)
        
        //set player to middle of current tile on map
        let playerPosition = character.movement.getOffsetLocation(point: character.sprite.node.position)
        character.sprite.node.position = map.tileMap.centerOfTile(atColumn: playerPosition.0, row: playerPosition.1)
        character.movement.currentLocation = playerPosition
        
        //sets camera to focus on player
        cam!.position = character.sprite.node.position
        
    }
    
    func showMovesMap(point: CGPoint) {
        //setups up the initial moves map - will move once a menu button is set for "move" action
        let playerPosition = character.movement.getOffsetLocation(point: point)
        let moves = character.movement.getRange(from: playerPosition)
        character.movement.highlightMoves(moves: moves)
        addChild(character.movement.movesMap)
    }
    
    //Allows for panning around the map
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
        // If the movement just began, save the first camera position
        if sender.state == .began {
            previousCameraPoint = self.camera!.position
        }
        // Perform the translation
        let translation = sender.translation(in: self.view)
        let newPosition = CGPoint(
            x: previousCameraPoint.x + translation.x * -1,
            y: previousCameraPoint.y + translation.y
        )
        camera.position = newPosition
    }

    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {
        let destination = character.movement.moveTo(point: pos)
        let moveToTile = SKAction.move(to: destination, duration: 0.25)
        if character.movement.moved == true {
            cam?.run(moveToTile)
            character.sprite.node.run(moveToTile)
            showMovesMap(point: destination)
            character.movement.moved = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            //detect force touch
            let maxForce = t.maximumPossibleForce
            let force = t.force
            let normalizedForce = force / maxForce
            
            let location = t.location(in: self)
            let node = self.atPoint(location)
            
            if normalizedForce >= 0.75 && node.name == "PlayerSprite" {
                actionMenu.isHidden = false
            }

            self.touchMoved(toPoint: t.location(in: self))
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.parent is ActionMenu {
            switch node.name {
            case "MoveButton":
                showMovesMap(point: character.sprite.node.position)
                actionMenu.isHidden = true
            case "EndTurn":
                gameState.enter(GameTurn.self)
                actionMenu.isHidden = true
            case "TileAction":
                print("Tile Action Button Pushed")
                actionMenu.isHidden = true
            case "Inventory":
                print("Inventory Button Pushed")
                actionMenu.isHidden = true
            default:
                print(node.name ?? "NO Name")
            }
        } else {
            if actionMenu.isHidden {
                self.touchUp(atPoint: location)
            }
            actionMenu.isHidden = true
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if gameState.currentState is GameTurn {
            gameState.enter(PlayerTurn.self)
        }
        
        //If moving happened, add the new tileMap to the scene and set the camera position and end the pan gesture
        if map.updateMap(point: camera?.position ?? CGPoint(x: 0.0, y: 0.0), zoom: 1.0) == true {
            self.addChild(map.tileMap)
            camera?.position = map.getTileCenter(point: CGPoint(x: 0.0, y: 0.0), inMap: map.tileMap)
            panGesture.cancel()
        }

        statMenu.update(character: character)
        
    }

}
