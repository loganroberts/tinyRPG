//
//  MovementComponent.swift
//  tinyRPG
//
//  Created by Logan Roberts on 2/28/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {
    
    var movesMap = SKNode()
    var moved = false
    var range = 2
    var maxMovementPoints = 2
    var movementPoints = 2
    
    var directions = [(1, -1, 0), (1, 0, -1), (0, 1, -1),
                      (-1, 1, 0), (-1, 0, 1), (0, -1, 1)]
    
    var diagonals = [(2, -1, -1), (1, 1, -2), (-1, 2, -1),
                     (-2, 1, 1), (-1, -1, 2), (1, -2, 1)]
    
    var map: MapGen
    var validTiles = [(Int, Int)]()
    
    var currentLocation = (0, 0)
    
    lazy var currentTile = map.tileMap.tileDefinition(atColumn: currentLocation.0, row: currentLocation.1)
    
    init(map: MapGen) {
        self.map = map
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
    func moveTo(point: CGPoint) -> CGPoint {
        
        let column = map.tileMap.tileColumnIndex(fromPosition: point)
        let row = map.tileMap.tileRowIndex(fromPosition: point)
        let tile = (column, row)
        
        //sets up a path from origin to the new location
        let currentCube = offsetToCube(column: currentLocation.0, row: currentLocation.1)
        let futureCube = offsetToCube(column: tile.0, row: tile.1)
        let path = getPath(from: currentCube, to: futureCube)
        
        //checks the cost for each step between origin and new location
        var totalCost = 0
        for each in path {
            if each != currentCube {
                //incriments the totalCost for all new tiles
                let loc = cubeToOffset(cube: each)
                let tileDef = map.tileMap.tileDefinition(atColumn: loc.0, row: loc.1)
                let cost = tileDef?.userData?.value(forKey: "cost") as! Int
                totalCost += cost
            }
        }
        
        var destination = map.tileMap.centerOfTile(atColumn: currentLocation.0, row: currentLocation.1)
        
        if validTiles.contains(where: { $0 == tile }) && totalCost <= movementPoints {
            destination = map.tileMap.centerOfTile(atColumn: column, row: row)
            moved = true
            currentLocation = (column, row)
        }
        movementPoints -= totalCost
        return destination
    }
 
    
    ///////Supporting Functions
    
    func getOffsetLocation(point: CGPoint) -> (Int, Int) {
        let column = map.tileMap.tileColumnIndex(fromPosition: point)
        let row = map.tileMap.tileRowIndex(fromPosition: point)
        
        return (column, row)
    }
    
    func offsetToCube(column: Int, row: Int) -> (Int, Int, Int){
        let x = (column - (row - (row&1)) / 2)
        let z = row
        let y = (-x - z)
        
        return(x, y, z)
    }
    
    func cubeToOffset(cube: (Int, Int, Int)) -> (Int, Int) {
        let column = cube.0 + (cube.2 - (cube.2&1)) / 2
        let row = cube.2
        return (column, row)
    }
    
    func cubeAdd(cubeA: (Int, Int, Int), cubeB: (Int, Int, Int)) -> (Int, Int, Int) {
        let result = ((cubeA.0 + cubeB.0), (cubeA.1 + cubeB.1), (cubeA.2 + cubeB.2))
        return result
    }
    
    func cubeSubtract(cubeA: (Int, Int, Int), cubeB: (Int, Int, Int)) -> (Int, Int, Int) {
        let result = ((cubeA.0 - cubeB.0), (cubeA.1 - cubeB.1), (cubeA.2 - cubeB.2))
        return result
    }
    
    func cubeRound(cube: (Double, Double, Double)) -> (Int, Int, Int) {
        var xi = round(cube.0)
        var yi = round(cube.1)
        var zi = round(cube.2)
        
        let xDiff = abs(xi - cube.0)
        let yDiff = abs(yi - cube.1)
        let zDiff = abs(zi - cube.2)
        
        if xDiff > yDiff && xDiff > zDiff {
            xi = (-yi - zi)
        } else if yDiff > zDiff {
            yi = (-xi - zi)
        } else {
            zi = (-xi - yi)
        }
        
        return (Int(xi), Int(yi), Int(zi))
    }
    
    func cubeNudge(cube: (Int, Int, Int)) -> (Double, Double, Double) {
        let result = (Double(cube.0) + 0.000001, Double(cube.1) + 0.000001, Double(cube.2) - 0.000002)
        return result
    }
    
    func getNeighbors(location: (Int, Int)) -> [(Int, Int, Int)] {
        let cubeLocation = offsetToCube(column: location.0, row: location.1)
        var neighbors = [(Int, Int, Int)]()
        
        for direction in directions {
            let result = cubeAdd(cubeA: cubeLocation, cubeB: direction)
            neighbors.append(result)
        }
        
        return neighbors
    }
    
    func getDistance(cubeA: (Int, Int, Int), cubeB: (Int, Int, Int)) -> Int {
        
        let x = abs(cubeA.0 - cubeB.0)
        let y = abs(cubeA.1 - cubeB.1)
        let z = abs(cubeA.2 - cubeB.2)
        
        let distance = max(x, y, z)
        
        return distance
        
    }
    
    //Linear Interpolation
    func lerp(a: (Double, Double, Double), b: (Double, Double, Double), t: Double) -> (Double, Double, Double) {
        let x = a.0 * (1.0 - t) + (b.0 * t)
        let y = a.1 * (1.0 - t) + (b.1 * t)
        let z = a.2 * (1.0 - t) + (b.2 * t)
        
        return (x, y, z)
    }
    
    func getPath(from: (Int, Int, Int), to: (Int, Int, Int)) -> [(Int, Int, Int)] {
        let d = getDistance(cubeA: from, cubeB: to)
        
        let aNudge = cubeNudge(cube: from)
        let bNudge = cubeNudge(cube: to)
        let step = 1.0 / max(Double(d), 1.0)
        
        var results = [(Int, Int, Int)]()
        
        let path1 = 000
        
        for i in 0...d {
            let t = step * Double(i)
            let lerpedCube = lerp(a: aNudge, b: bNudge, t: t)
            let result = cubeRound(cube: lerpedCube)
            results.append(result)
        }
        
        return results
    }
    
    func getRange(from: (Int, Int)) -> [(Int, Int)] {
        let origin = offsetToCube(column: from.0, row: from.1)
        var visited = [origin]
        var fringes = [[(origin)]]
        
        var validTiles = [(Int, Int)]()
        
        for k in 1...range {
            let emptyA = [(Int, Int, Int)]()
            fringes.append(emptyA)
            for tile in fringes[k - 1] {
                let neighbors = getNeighbors(location: cubeToOffset(cube: tile))
                for neighbor in neighbors {
                    if visited.contains(where: { $0 == neighbor })  {
                    } else {
                        visited.append(neighbor)
                        fringes[k].append(neighbor)
                    }
                }
            }
            
            for (index, member) in visited.enumerated() {
                if member == origin {
                    visited.remove(at: index)
                } else {
                    validTiles.append(cubeToOffset(cube: member))
                }
            }
        }
        
        let results = filterMovementCost(origin: offsetToCube(column: from.0, row: from.1), range: validTiles)
        
        
        return results
    }
    
    func filterMovementCost(origin: (Int, Int, Int), range: [(Int, Int)]) -> [(Int, Int)] {
        var validMoves = [(Int, Int, Int)]()
        var validCoordinates = [(Int, Int)]()
        
        for each in range {
            let path = getPath(from: origin, to: offsetToCube(column: each.0, row: each.1))
            var pathCost = 0
            for step in path {
                if step != origin {
                    let tile = map.tileMap.tileDefinition(atColumn: cubeToOffset(cube: step).0, row: cubeToOffset(cube: step).1)
                    let cost = tile?.userData?.value(forKey: "cost") as? Int ?? 5
                    pathCost += cost
                    if pathCost <= movementPoints {
                        if !validMoves.contains(where: { $0 == step }) {
                            validMoves.append(step)
                        }
                    }
                }
            }
        }
        for each in validMoves {
            validCoordinates.append(cubeToOffset(cube: each))
        }
        validTiles = validCoordinates
        return validCoordinates
    }
    
    func highlightMoves(moves: [(Int, Int)]) {
        clearMoveMap()
        let movesMapNode = SKTileMapNode(tileSet: map.tileSet!, columns: map.columns, rows: map.rows, tileSize: CGSize(width: 125, height: 144))
        movesMapNode.zPosition = 2
        movesMapNode.name = "movesMapNode"
        for move in moves {
            movesMapNode.setTileGroup(map.tileSet!.tileGroups.first( where: { $0.name == "blank"}), forColumn: move.0, row: move.1)
        }
        movesMap.addChild(movesMapNode)
    }
    
    func clearMoveMap() {
        movesMap.childNode(withName: "movesMapNode")?.removeFromParent()
        movesMap.removeFromParent()
    }
}
