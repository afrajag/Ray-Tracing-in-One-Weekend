//
//  NoiseTexture.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 19/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

struct NoiseTexture: Texture {
    
    var noise: Perlin
    var scale: Double
    
    func value(u: Double, v: Double, p: Vector3) -> Vector3 {
        return Vector3(1,1,1) * 0.5 * (1 + sin(scale*p.z + 10 * noise.turbulence(p: p, depth: 7)))
    }
}

