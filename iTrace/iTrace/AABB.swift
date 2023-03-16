//
//  AABB.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 10/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

import simd

func ffmin(a: Double, b: Double) -> Double { return a < b ? a : b }
func ffmax(a: Double, b: Double) -> Double { return a > b ? a : b }

func surrounding_box(box0: AABB, box1: AABB) -> AABB {
    
    let small = Vector3(ffmin(a: box0.min.x, b: box1.min.x), ffmin(a: box0.min.y, b: box1.min.y), ffmin(a: box0.min.z, b: box1.min.z))
    
    let big = Vector3(ffmax(a: box0.max.x, b: box1.max.x), ffmax(a: box0.max.y, b: box1.max.y), ffmax(a: box0.max.z, b: box1.max.z))
    
    return AABB(min: small, max: big)
}

struct AABB {

    let min, max: Vector3
    
    func hit(r: Ray, t_min: Double, t_max: Double) -> Bool {
       
        /*
        for (int a = 0; a < 3; a++) {
            Double invD = 1.0f / r.direction()[a];
            Double t0 = (min()[a] - r.origin()[a]) * invD;
            Double t1 = (max()[a] - r.origin()[a]) * invD;
            if (invD < 0.0f)
                std::swap(t0, t1);
            tmin = t0 > tmin ? t0 : tmin;
            tmax = t1 < tmax ? t1 : tmax;
            if (tmax <= tmin)
                return false;
        }
        */
        
        for _ in 0..<3 {
            
            let t0: Double = ffmin(a: (min.x - r.origin.x) / r.direction.x, b: (max.x - r.origin.x) / r.direction.x)
            
            let t1: Double = ffmax(a: (min.x - r.origin.x) / r.direction.x, b: (max.x - r.origin.x) / r.direction.x)
            
            let t_min_app = ffmax(a: t0, b: t_min)
            let t_max_app = ffmin(a: t1, b: t_max)
            
            if (t_max_app <= t_min_app) {
                return false
            }
        }
        
        return true
    }
}
