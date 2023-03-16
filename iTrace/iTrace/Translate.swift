//
//  Translate.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 20/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

class Translate: Object {
    let offset: Vector3
    let obj: Object
    
    init(obj: Object, displacement: Vector3) {
        self.obj = obj
        self.offset = displacement
    }
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool {
        let moved_r = Ray(origin: r.origin - offset, direction: r.direction, time: r.time);
        
        if (obj.hit(r: moved_r, t_min: t_min, t_max: t_max, hit: &hit)) {
            hit.p += offset
            return true
        } else {
            return false
        }
    }
    
    func bounding_box(t0: Double, t1: Double) -> AABB? {
        if let bb = obj.bounding_box(t0: t0, t1: t1) {
            return AABB(min: bb.min + offset, max: bb.max + offset)
        }
            
        return nil
    }
}
