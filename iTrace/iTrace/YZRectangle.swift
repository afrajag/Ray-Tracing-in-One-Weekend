//
//  YZRectangle.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 20/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

class YZRectangle: Object {
    let y0, y1, z0, z1, k: Double
    var mat: Material
    
    init(y0: Double, y1: Double, z0: Double, z1: Double, k: Double, mat: Material) {
        self.y0 = y0
        self.y1 = y1
        self.z0 = z0
        self.z1 = z1
        self.k = k
        self.mat = mat
    }
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool {
        let t: Double = (k-r.origin.x) / r.direction.x
        
        if (t < t_min || t > t_max) {
            return false
        }
        
        let y: Double = r.origin.y + t*r.direction.y
        let z: Double = r.origin.z + t*r.direction.z
        
        if (z < z0 || z > z1 || y < y0 || y > y1) {
            return false
        }
        
        hit.u = (y-y0)/(y1-y0)
        hit.v = (z-z0)/(z1-z0)
        hit.t = t
        hit.mat = mat
        hit.p = r.pointAt(t: t)
        hit.normal = Vector3(1, 0, 0)
        
        return true
    }
    
    func bounding_box(t0: Double, t1: Double) -> AABB? {
        return AABB(min: Vector3(k-0.0001, y0, z0), max: Vector3(k-0.0001, y1, z1))
    }
}
