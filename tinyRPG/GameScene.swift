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
    var previousCameraScale = CGFloat()
    
    let maxZoom = CGFloat(2.0)
    let minZoom = CGFloat(1.0)
    var lastZoom = CGFloat(1.0)
    
    var cameraDeltaX = Double()
    var cameraDeltaY = Double()
    
    let panGesture = UIPanGestureRecognizer()
    let pinchGesture = UIPinchGestureRecognizer()
    
    var gameState: GKStateMachine!
    //Helper character for testing. DO NOT REFERENCe
    lazy var character = Character(texture: SKTexture(imageNamed: "hero"), map: map)
    
    override func sceneDidLoad() {
        
        entities.append(character)
        addChild(map.tileMap)
        addChild(character.sprite.node)
    }
    
    //Sets up gestures and camera in scene
    override func didMove(to view: SKView) {
        
        panGesture.addTarget(self, action: #selector(panGestureAction(_:)))
        pinchGesture.addTarget(self, action: #selector(handlePinchGesture(sender:)))
      
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(pinchGesture)
        
        //setup camera
        cam = SKCameraNode()
        
        self.camera = cam
        self.addChild(cam!)
        let bottomMenu = BottomMenu()
        let topMenu = TopMenu()
        bottomMenu.position = CGPoint(x: 0, y: -570)
        topMenu.position = CGPoint(x: 0, y: 640)
        
        cam?.addChild(bottomMenu)
        cam?.addChild(topMenu)
        
        let playerPosition = character.movement.getOffsetLocation(point: character.sprite.node.position)
        character.sprite.node.position = map.tileMap.centerOfTile(atColumn: playerPosition.0, row: playerPosition.1)
        character.movement.currentLocation = playerPosition
        
        cam!.position = character.sprite.node.position
        let moves = character.movement.getRange(from: playerPosition)
        character.movement.highlightMoves(moves: moves)
        addChild(character.movement.movesMap)
        
        gameState = GKStateMachine(states: [PlayerTurn(game: self, player: character), GameTurn()])
        gameState.enter(PlayerTurn.self)
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
    
    //allows for zooming
    @objc func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else { return }
        
        if sender.state == .began {
            previousCameraScale = camera.xScale
        }
        
        if sender.state == .changed {
            switch (previousCameraScale * 1 / sender.scale) {
            case 1.0 ... 3.0:
                camera.setScale(previousCameraScale * 1 / sender.scale)
            case ..<1.0:
                camera.setScale(1.0)
            case 3.0...:
                camera.setScale(3.0)
            default:
                print("SKCamera Scale Broken")
            }
            
            if (previousCameraScale * 1 / sender.scale) > 3.0 {
                camera.setScale(3.0)
                lastZoom = 3.0
            } else if (previousCameraScale * 1 / sender.scale) < 1.0 {
                camera.setScale(1.0)
                lastZoom = 1.0
            } else {
                camera.setScale(previousCameraScale * 1 / sender.scale)
                lastZoom = (previousCameraScale * 1 / sender.scale)
            }
        }
        
        
        
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
        }
        
        character.sprite.node.run(moveToTile)
        
        let playerPosition = character.movement.getOffsetLocation(point: destination)
        let moves = character.movement.getRange(from: playerPosition)
        character.movement.highlightMoves(moves: moves)
        character.movement.moved = false
        addChild(character.movement.movesMap)
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
            let nodeAtTouch = cam?.atPoint(t.location(in: cam!))
            switch nodeAtTouch?.name {
            case "button1":
                cam?.position = character.sprite.node.position
            case "button2":
                print("Found Button 2")
            case "button3":
                print("Found Button 3")
            case "button4":
                gameState.enter(GameTurn.self)
            default:
                print("")
            }
            
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
        if map.updateMap(point: camera?.position ?? CGPoint(x: 0.0, y: 0.0), zoom: lastZoom) == true {
            self.addChild(map.tileMap)
            camera?.position = map.getTileCenter(point: CGPoint(x: 0.0, y: 0.0), inMap: map.tileMap)
            panGesture.cancel()
        }
        
        //moves the character to the camera center. this will be removed once player movement is independent
        
        character.update(deltaTime: currentTime)
        
        (cam?.childNode(withName: "TopMenu") as! TopMenu).levelLabel.text = "Level: \(character.experience.level)"
        (cam?.childNode(withName: "TopMenu") as! TopMenu).healthLabel.text = "HP: \(character.health.current)"
    }

}
