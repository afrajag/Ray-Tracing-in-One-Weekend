//
//  FlipNormals.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 20/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

class FlipNormals: Object {
    let obj: Object
    
    init(obj: Object) {
        self.obj = obj
    }
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool {
        if (obj.hit(r: r, t_min: t_min, t_max: t_max, hit: &hit)) {
            hit.normal = -hit.normal
            return true
        } else {
            return false
        }
    }
    
    func bounding_box(t0: Double, t1: Double) -> AABB? {
        return obj.bounding_box(t0: t0, t1: t1)
    }
}
