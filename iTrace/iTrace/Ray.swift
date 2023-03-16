//
//  ray.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 05/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

struct Ray
{
    let origin: Vector3
    let direction: Vector3
    let time: Double
    
    func pointAt(t: Double) -> Vector3 {
        return origin + t*direction
    }
}
