//
//  XZRectangle.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 20/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

class XZRectangle: Object {
    let x0, x1, z0, z1, k: Double
    var mat: Material
    
    init(x0: Double, x1: Double, z0: Double, z1: Double, k: Double, mat: Material) {
        self.x0 = x0
        self.x1 = x1
        self.z0 = z0
        self.z1 = z1
        self.k = k
        self.mat = mat
    }
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool {
        let t: Double = (k-r.origin.y) / r.direction.y
        
        if (t < t_min || t > t_max) {
            return false
        }
        
        let x: Double = r.origin.x + t*r.direction.x
        let z: Double = r.origin.z + t*r.direction.z
        
        if (x < x0 || x > x1 || z < z0 || z > z1) {
            return false
        }
        
        hit.u = (x-x0)/(x1-x0)
        hit.v = (z-z0)/(z1-z0)
        hit.t = t
        hit.mat = mat
        hit.p = r.pointAt(t: t)
        hit.normal = Vector3(0, 1, 0)
        
        return true
    }
    
    func bounding_box(t0: Double, t1: Double) -> AABB? {
        return AABB(min: Vector3(x0, k-0.0001, z0), max: Vector3(x1, k-0.0001, z1))
    }
}
