//
//  metal.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 06/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

class Metal: Material {
    let fuzz: Double
    let albedo:Vector3

    init (albedo: Vector3, f: Double) {
        self.albedo = albedo
        self.fuzz = f < 1.0 ? f : 1.0
    }
    
    func scatter(r_in: Ray, hit: HitRecord, attenuation: inout Vector3, scattered: inout Ray) -> Bool {
        let reflected: Vector3 = reflect(v: r_in.direction.normalize, n: hit.normal)
        
        scattered = Ray(origin: hit.p, direction: reflected + fuzz * random_in_unit_sphere(), time: 0.0)
        
        attenuation = albedo
        
        return scattered.direction • hit.normal > 0
    }
}
