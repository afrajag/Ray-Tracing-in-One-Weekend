//
//  DiffuseMaterial.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 20/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

class DiffuseLight: Material {
    var light_ambient = Color(0.2, 0.2, 0.2) // ia
    var light_diffuse = Color(0.7, 0.7, 0.7) // id
    var light_specular = Color(0.7, 0.7, 0.7) // is
    
    let emit: Texture

    init (a: Texture) {
        self.emit = a
    }

    func emitted(u: Double, v: Double, p: Vector3) -> Vector3 {
        return emit.value(u: u, v: v, p: p)
    }
    
    func shade(r_in: Ray, hit: HitRecord) -> Vector3 {
        return Vector3.Dummy
    }
}
