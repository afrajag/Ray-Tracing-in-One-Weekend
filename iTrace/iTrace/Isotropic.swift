//
//  Isotropic.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 20/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

class Isotropic: Material {
    let albedo:Texture

    init (a: Texture) {
        self.albedo = a
    }
    
    func scatter(r_in: Ray, hit: HitRecord, attenuation: inout Vector3, scattered: inout Ray) -> Bool {
        let target: Vector3 = random_in_unit_sphere()
        
        scattered = Ray(origin: hit.p, direction: target, time: r_in.time)
        
        attenuation = albedo.value(u: hit.u, v: hit.v, p: hit.p)
        
        return true
    }
}
