import UIKit
import GameplayKit
import SpriteKit


let biomeNoise = GKNoise(GKVoronoiNoiseSource(frequency: 3, displacement: 1, distanceEnabled: false, seed: 2222))
let biomeMap = GKNoiseMap(biomeNoise, size: vector2(1.0, 1.0), origin: vector2(0, 0), sampleCount: vector2(1000, 1000), seamless: false)
let bTexture = SKTexture(noiseMap: biomeMap)



let biomeNoise1 = GKNoise(GKVoronoiNoiseSource(frequency: 3, displacement: 1, distanceEnabled: false, seed: 2222))
biomeNoise1.move(by: vector3(0.01, 0.0, 0.0))
let biomeMap1 = GKNoiseMap(biomeNoise1, size: vector2(1.0, 1.0), origin: vector2(0.0, 0.0), sampleCount: vector2(1000, 1000), seamless: false)
let bTexture1 = SKTexture(noiseMap: biomeMap1)
