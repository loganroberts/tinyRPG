//
//  MapGen.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/7/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class MapGen {
    //List of valid biomes for tile Data
    enum Biome {
        case Ocean
        case Beach
        case Grassland
        case Forest
        case Rainforest
        case Desert
        case Mountain
        case Taiga
        case MountainSnow
        case MountainForest
        case Snow
        case Blank
    }
    
    
    //Noise Setup. One for height(and temperature) and one for moisture
    let moistureNoise = GKNoise(GKPerlinNoiseSource(
        frequency: 2,
        octaveCount: 8,
        persistence: 0.8,
        lacunarity: 1.5,
        seed: Int32(arc4random_uniform(5000 - 1))))

    let heightNoise = GKNoise(GKPerlinNoiseSource(
        frequency: 2,
        octaveCount: 8,
        persistence: 0.8,
        lacunarity: 1.5,
        seed: Int32(arc4random_uniform(5000 - 1))))

   
 //   p.userData = NSMutableDictionary(dictionary: ["cost": 1])
    
    // all tile groups for terrain
    lazy var blankDef = SKTileDefinition(texture: SKTexture(imageNamed: "blank"))
    lazy var beachDef = SKTileDefinition(texture: SKTexture(imageNamed: "beach"))
    lazy var desertDef = SKTileDefinition(texture: SKTexture(imageNamed: "desert"))
    lazy var forestDef = SKTileDefinition(texture: SKTexture(imageNamed: "forest"))
    lazy var grassDef = SKTileDefinition(texture: SKTexture(imageNamed: "grass"))
    lazy var mountainDef = SKTileDefinition(texture: SKTexture(imageNamed: "mountain"))
    lazy var mountainForestDef = SKTileDefinition(texture: SKTexture(imageNamed: "mountainForest"))
    lazy var mountainSnowDef = SKTileDefinition(texture: SKTexture(imageNamed: "mountainSnow"))
    lazy var oceanDef = SKTileDefinition(texture: SKTexture(imageNamed: "ocean"))
    lazy var rainForestDef = SKTileDefinition(texture: SKTexture(imageNamed: "rainForest"))
    lazy var snowDef = SKTileDefinition(texture: SKTexture(imageNamed: "snow"))
    lazy var taigaDef = SKTileDefinition(texture: SKTexture(imageNamed: "taiga"))

    lazy var blank = SKTileGroup(tileDefinition: blankDef)
    lazy var beach = SKTileGroup(tileDefinition: beachDef)
    lazy var desert = SKTileGroup(tileDefinition: desertDef)
    lazy var forest = SKTileGroup(tileDefinition: forestDef)
    lazy var grass = SKTileGroup(tileDefinition: grassDef)
    lazy var mountain = SKTileGroup(tileDefinition: mountainDef)
    lazy var mountainForest = SKTileGroup(tileDefinition: mountainForestDef)
    lazy var mountainSnow = SKTileGroup(tileDefinition: mountainSnowDef)
    lazy var ocean = SKTileGroup(tileDefinition: oceanDef)
    lazy var rainForest = SKTileGroup(tileDefinition: rainForestDef)
    lazy var snow = SKTileGroup(tileDefinition: snowDef)
    lazy var taiga = SKTileGroup(tileDefinition: taigaDef)
    
    var tileSet = SKTileSet()
    
    // tileMap setup
    var tileMap: SKTileMapNode
    var columns: Int
    var rows: Int

    var currentTileIndex = (0, 0)
   
    init(columns: Int, rows: Int) {

        self.columns = columns
        self.rows = rows
        
        self.tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: CGSize(width: 125, height: 144))

        heightNoise.clamp(lowerBound: -0.1, upperBound: 1.0)
        heightNoise.raiseToPower(4)
        blankDef.userData = NSMutableDictionary(dictionary: ["cost": 0])
        beachDef.userData = NSMutableDictionary(dictionary: ["cost": 1])
        desertDef.userData = NSMutableDictionary(dictionary: ["cost": 1])
        forestDef.userData = NSMutableDictionary(dictionary: ["cost": 2])
        grassDef.userData = NSMutableDictionary(dictionary: ["cost": 1])
        mountainDef.userData = NSMutableDictionary(dictionary: ["cost": 3])
        mountainForestDef.userData = NSMutableDictionary(dictionary: ["cost": 3])
        mountainSnowDef.userData = NSMutableDictionary(dictionary: ["cost": 3])
        oceanDef.userData = NSMutableDictionary(dictionary: ["cost": 5])
        rainForestDef.userData = NSMutableDictionary(dictionary: ["cost": 2])
        snowDef.userData = NSMutableDictionary(dictionary: ["cost": 1])
        taigaDef.userData = NSMutableDictionary(dictionary: ["cost": 1])
        
        
        self.tileSet = SKTileSet(tileGroups: [blank, beach, desert, forest, grass, mountain, mountainForest, mountainSnow, ocean, rainForest, snow, taiga], tileSetType: .hexagonalPointy)
        self.tileMap = createMap(columns: columns, rows: rows)
        
    }
    
    /*
     Creates an updated map aftermovement by using the utility function to adjust noisemaps.
     If no movement, does nothing. Returns bool back to the GameScene for use in the Update()
     function.
     */
    
    func updateMap(point: CGPoint, zoom: CGFloat) -> Bool {
        var modified = false
        
        currentTileIndex = getOffsetLocation(point: point, inMap: tileMap)
        
        let mapOffsetCenter = (tileMap.numberOfColumns / 2, tileMap.numberOfRows / 2 - 1)
        let movedTiles = (currentTileIndex.0 - mapOffsetCenter.0, currentTileIndex.1 - mapOffsetCenter.1)
        
        //set zoom level for tile offsets
        let xBorder = Int(round(zoom) * 4)
        let yBorder = Int(round(zoom) * 7)
     
        //check if camera.position.x is in bounds
        switch currentTileIndex.0 {
        case ..<xBorder:
            adjustMap(y: 0.0, x: Double(movedTiles.0))
            modified = true
        case (columns - xBorder)...:
            adjustMap(y: 0.0, x: Double(movedTiles.0))
            modified = true
        default:
            modified = false
        }
        
        //check if camera.position.y is in bounds
        switch currentTileIndex.1 {
        case ..<yBorder:
            adjustMap(y: Double(movedTiles.1 / 2), x: 0.0 )
            modified = true
        case (rows - yBorder)...:

            adjustMap(y: Double(movedTiles.1 / 2), x: 0.0)
            modified = true
        default:
            if modified == false {
                modified = false
            }
        }
        
        return modified
    }
    
    
    //Utility Function to adjust the Noise that the tilemap is crated from. Also creates the updated Tilemap
    func adjustMap(y: Double, x: Double) {
        let _x = x * 0.01
        let _y = y * 0.01
        tileMap.removeFromParent()
        heightNoise.move(by: vector3(_y, 0.0, _x))
        moistureNoise.move(by: vector3(_y, 0.0, _x))
        tileMap = createMap(columns: columns, rows: rows)
    }
    
    //Helper to easily convert CGPoints (like touch points) to tiles in the map
    func getOffsetLocation(point: CGPoint, inMap: SKTileMapNode) -> (Int, Int) {
        let column = inMap.tileColumnIndex(fromPosition: point)
        let row = inMap.tileRowIndex(fromPosition: point)
        return (column, row)
    }
    
    //Gets the center tile on screen in point (for passing back to the camera.position)
    func getTileCenter(point: CGPoint, inMap: SKTileMapNode) -> CGPoint {
        let offset = getOffsetLocation(point: point, inMap: inMap)
        let centerPoint = tileMap.centerOfTile(atColumn: offset.0, row: offset.1)
        return centerPoint
    }
    
     /*
     Map generation function. Sets the noiseMaps from the preset noiseSources.
     Creates a TileMap and then iterates to create biome data by comparing the HeightMap to the Moisture Map
     Calls the setBiome helper function to get the results
     */
    func createMap(columns: Int, rows: Int) -> SKTileMapNode {
        let elevationMap = GKNoiseMap(heightNoise)
        let moistureMap = GKNoiseMap(moistureNoise)
        
        let map = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: CGSize(width: 125, height: 144))
        
        for column in 0 ..< columns {
            for row in 0 ..< rows {
                let location = vector2(Int32(row), Int32(column))
                let tileBiome = setBiome(location: location, e: elevationMap, m: moistureMap)
                
                switch tileBiome {
                case .Ocean:
                    map.setTileGroup(ocean, forColumn: column, row: row)
                case .Beach:
                    map.setTileGroup(beach, forColumn: column, row: row)
                case .Grassland:
                    map.setTileGroup(grass, forColumn: column, row: row)
                case .Forest:
                    map.setTileGroup(forest, forColumn: column, row: row)
                case .Rainforest:
                    map.setTileGroup(rainForest, forColumn: column, row: row)
                case .Desert:
                    map.setTileGroup(desert, forColumn: column, row: row)
                case .Mountain:
                    map.setTileGroup(mountain, forColumn: column, row: row)
                case .MountainSnow:
                    map.setTileGroup(mountainSnow, forColumn: column, row: row)
                case .MountainForest:
                    map.setTileGroup(mountainForest, forColumn: column, row: row)
                case .Snow:
                    map.setTileGroup(snow, forColumn: column, row: row)
                case .Taiga:
                    map.setTileGroup(taiga, forColumn: column, row: row)
                case .Blank:
                    map.setTileGroup(blank, forColumn: column, row: row)
                }
                
            }
        }
        return map
    }

    // Get the elevation and compare against a moisture map for biome generation and return the Biome for tilemap creation
    func setBiome(location: simd_int2, e: GKNoiseMap, m: GKNoiseMap) -> Biome {
        let eV = e.value(at: location)
        let mV = m.value(at: location)
        var biome: Biome = .Blank
        
        //Check for Ocean/Beach
        guard eV > -0.5 else {
            if eV > -0.51 {
                biome = .Beach
            } else {
                biome =  .Ocean
            }
            return biome
        }
        
        if eV > -0.5 && eV < -0.25 {
            switch mV {
            case -1.0 ... -0.75:
                biome =  .Desert
            case -0.75 ... -0.5:
                biome =  .Grassland
            case -0.5 ... 0.25:
                biome =  .Forest
            case 0.25 ... 1.0:
                biome =  .Rainforest
            default:
                print("Tropical Biome outside range")
                biome =  .Blank
            }
            return biome
        }
        
        if eV > -0.25 && eV < 0.25 {
            switch mV {
            case -1.0 ... -0.5:
                biome =  .Desert
            case -0.5 ... 0.0:
                biome =  .Grassland
            case 0.0 ... 1.0:
                biome =  .Forest
            default:
                print("Temperate Biome outside range")
                biome =  .Blank
            }
            return biome
        }
        
        if eV > 0.25 && eV < 0.5 {
            switch mV {
            case -1.0 ... -0.25:
                biome =  .Desert
            case -0.25 ... 0.25:
                biome =  .Taiga
            case 0.25 ... 1.0:
                biome =  .Snow
            default:
                print("Arctic Biome outside range")
                biome =  .Blank
            }
            return biome
        }
        
        if eV > 0.5 && eV <= 1.0 {
            switch mV {
            case -1.0 ... -0.25:
                biome =  .Mountain
            case -0.25 ... 0.25:
                biome =  .MountainForest
            case 0.25 ... 1.0:
                biome =  .MountainSnow
            default:
                print("Mountain Biome outside range")
                biome =  .Blank
            }
            return biome
        }
        
        return biome
    }
    

}
