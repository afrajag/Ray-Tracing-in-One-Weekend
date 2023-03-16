//
//  sphere.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 05/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

class Sphere: Object {
    let center: Vector3
    let radius: Double
    var mat: Material
    
    init(cen: Vector3, r: Double, mat: Material) {
        self.center = cen
        self.radius = r
        self.mat = mat
    }
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool {
        let oc: Vector3 = r.origin - center
        let a: Double = r.direction • r.direction
        let b: Double = oc • r.direction
        let c: Double = oc • oc - radius * radius
        
        let discriminant: Double = b*b - a*c
        
        if (discriminant > 0) {
            
            var temp: Double = (-b - sqrt(discriminant))/a

            if (temp < t_max && temp > t_min) {
                
                hit.t = temp
                hit.p = r.pointAt(t: hit.t)
                hit.normal = (hit.p - center) / radius
                hit.mat = self.mat
                
                (hit.u, hit.v) = get_sphere_uv(p: hit.normal)
                
                return true
            }
            
            temp = (-b + sqrt(discriminant))/a

            if (temp < t_max && temp > t_min) {
                
                hit.t = temp
                hit.p = r.pointAt(t: hit.t)
                hit.normal = (hit.p - center) / radius
                hit.mat = self.mat
                
                (hit.u, hit.v) = get_sphere_uv(p: hit.normal)
                
                return true
            }
        }
        
        return false
    }
    
    func bounding_box(t0: Double, t1: Double) -> AABB? {
        return AABB(min: center - Vector3(radius, radius, radius), max: center + Vector3(radius, radius, radius))
    }
    
    func get_sphere_uv(p: Vector3) -> (u: Double, v: Double) {
        let phi: Double = atan2(p.z, p.x)
        let theta: Double = asin(p.y)
        
        return (1-(phi + Double.pi) / (2*Double.pi), (theta + Double.pi/2) / Double.pi)
    }
}
