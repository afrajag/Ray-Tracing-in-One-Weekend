//
//  Rectangle.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 20/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

class XYRectangle: Object {
    let x0, x1, y0, y1, k: Double
    var mat: Material
    
    init(x0: Double, x1: Double, y0: Double, y1: Double, k: Double, mat: Material) {
        self.x0 = x0
        self.x1 = x1
        self.y0 = y0
        self.y1 = y1
        self.k = k
        self.mat = mat
    }
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool {
        let t: Double = (k-r.origin.z) / r.direction.z
        
        if (t < t_min || t > t_max) {
            return false
        }
        
        let x: Double = r.origin.x + t*r.direction.x
        let y:Double = r.origin.y + t*r.direction.y
        
        if (x < x0 || x > x1 || y < y0 || y > y1) {
            return false
        }
        
        hit.u = (x-x0)/(x1-x0)
        hit.v = (y-y0)/(y1-y0)
        hit.t = t
        hit.mat = mat
        hit.p = r.pointAt(t: t)
        hit.normal = Vector3(0, 0, 1)
        
        return true
    }
    
    func bounding_box(t0: Double, t1: Double) -> AABB? {
        return AABB(min: Vector3(x0, y0, k-0.0001), max: Vector3(x1, y1, k+0.0001))
    }
}
