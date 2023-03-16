//
//  dielectric.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 06/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

class Dielectric: Material {
    let ref_idx: Double

    init (ref_idx: Double) {
        self.ref_idx = ref_idx
    }
    
    func scatter(r_in: Ray, hit: HitRecord, attenuation: inout Vector3, scattered: inout Ray) -> Bool {
        let outward_normal: Vector3
        let reflected: Vector3 = reflect(v: r_in.direction, n: hit.normal)
        let ni_over_nt:Double
        
        attenuation = Vector3(1.0, 1.0, 1.0)
        
        var refracted = Vector3(1.0, 1.0, 1.0)

        let reflect_prob: Double
        let cosine: Double
        
        if (r_in.direction • hit.normal) > 0 {
            outward_normal = -hit.normal
            
            ni_over_nt = ref_idx

            cosine = ref_idx * (r_in.direction • hit.normal) / r_in.direction.length
        } else {
            outward_normal = hit.normal
            
            ni_over_nt = 1.0 / ref_idx

            cosine = -(r_in.direction • hit.normal) / r_in.direction.length
        }

        if refract(v: r_in.direction, n: outward_normal, niOverNt: ni_over_nt, refracted: &refracted) {
            reflect_prob = schlick(cosine: cosine, ref_idx: ref_idx)
        } else {
            reflect_prob = 1.0
        }
        
        if (Double.random(in: 0..<1) < reflect_prob) {
            scattered = Ray(origin: hit.p, direction: reflected, time: 0.0)
        } else {
            scattered = Ray(origin: hit.p, direction: refracted, time: 0.0)
        }
        
        return true
    }
}
