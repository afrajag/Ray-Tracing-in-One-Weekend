//
//  ConstantMedium.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 20/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

class ConstantMedium: Object {
    let boundary: Object
    let density: Double
    var phase_function: Material
    
    init(obj: Object, d: Double, a: Texture) {
        self.boundary = obj
        self.density = d
        
        phase_function = Isotropic(a: a)
    }
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool {
        var hit1 = HitRecord(t: 0.0, p: Vector3.Dummy, normal: Vector3.Dummy, mat: Metal(albedo: Vector3.Dummy, f: 1.0), u: 0.0, v: 0.0) // just for init variable
        var hit2 = HitRecord(t: 0.0, p: Vector3.Dummy, normal: Vector3.Dummy, mat: Metal(albedo: Vector3.Dummy, f: 1.0), u: 0.0, v: 0.0)
        
        if boundary.hit(r: r, t_min: -Double.greatestFiniteMagnitude, t_max: Double.greatestFiniteMagnitude, hit: &hit1) {
            if boundary.hit(r: r, t_min: hit1.t + 0.0001, t_max: Double.greatestFiniteMagnitude, hit: &hit2) {
                if hit1.t < t_min {
                    hit1.t = t_min
                }
                
                if hit2.t > t_max {
                    hit2.t = t_max
                }
                
                if (hit1.t >= hit2.t) {
                    return false
                }
                
                if (hit1.t < 0) {
                    hit1.t = 0
                }
                
                let distanceInsideBoundary = (hit2.t - hit1.t) * r.direction.length
                let hit_distance = -(1.0 / density) * log(Double.random(in: 0..<1))
                
                if hit_distance < distanceInsideBoundary {
                    hit.t = hit1.t + hit_distance / r.direction.length
                    hit.p = r.pointAt(t: hit.t)
                    
                    hit.p = r.pointAt(t: hit.t)
                    hit.normal = Vector3(1,0,0)  // arbitrary
                    hit.mat = phase_function
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func bounding_box(t0: Double, t1: Double) -> AABB? {
        return boundary.bounding_box(t0: t0, t1: t1)
    }
}
