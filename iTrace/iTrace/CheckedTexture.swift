//
//  CheckedTexture.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 19/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

struct CheckedTexture: Texture {
    
    var odd: Texture
    var even: Texture
    
    func value(u: Double, v: Double, p: Vector3) -> Vector3 {
        let sines: Double = sin(10*p.x)*sin(10*p.y)*sin(10*p.z)
        
        if (sines < 0) {
            return odd.value(u: u, v: v, p: p)
        } else {
            return even.value(u: u, v: v, p: p)
        }
    }
}
