//
//  Texture.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 19/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

protocol Texture {
    
    func value(u: Double, v: Double, p: Vector3) -> Vector3
}

struct ConstantTexture: Texture {
    
    var color :Vector3
    
    func value(u: Double, v: Double, p: Vector3) -> Vector3 {
        return color
    }
}


