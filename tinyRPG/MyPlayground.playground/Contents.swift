import UIKit
import GameplayKit
import SpriteKit


let biomeNoise = GKNoise(GKVoronoiNoiseSource(frequency: 3, displacement: 1, distanceEnabled: false, seed: 2222))
let biomeMap = GKNoiseMap(biomeNoise, size: vector2(1.0, 1.0), origin: vector2(0, 0), sampleCount: vector2(1000, 1000), seamless: false)
let bTexture = SKTexture(noiseMap: biomeMap)



let riverNoise = GKNoise(GKRidgedNoiseSource(frequency: 6.0, octaveCount: 2, lacunarity: 5, seed: 1234))
let riverMap = GKNoiseMap(riverNoise, size: vector2(1.0, 1.0), origin: vector2(0, 0), sampleCount: vector2(1000, 1000), seamless: false)
let rTexture = SKTexture(noiseMap: riverMap)
