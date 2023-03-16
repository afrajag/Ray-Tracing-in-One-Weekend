//
//  MovingSphere.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 10/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

class MovingSphere: Object {

    let center0, center1: Vector3
    let radius: Double
    var mat: Material
    
    let time0, time1: Double
    
    init(cen0: Vector3, cen1: Vector3, t0: Double, t1: Double, r: Double, mat: Material) {
        
        self.center0 = cen0
        self.center1 = cen1
        self.radius = r
        self.mat = mat
        self.time0 = t0
        self.time1 = t1
    }
    
    func center(time: Double) -> Vector3 {
        return center0 + ((time - time0) / (time1 - time0))*(center1 - center0)
    }
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool {
        
        let oc: Vector3 = r.origin - center(time: r.time)
        let a: Double = r.direction • r.direction // simd_dot(r.direction, r.direction)
        let b: Double = oc • r.direction // simd_dot(oc, r.direction)
        let c: Double = oc • oc - radius * radius // simd_dot(oc, oc) - radius*radius
        let discriminant: Double = b*b - a*c
        
        if (discriminant > 0) {
            
            var temp: Double = (-b - sqrt(discriminant))/a
            
            //print("\(discriminant) -> \(t_min) > \(temp) < \(t_max)")
            
            if (temp < t_max && temp > t_min) {
                
                hit.t = temp
                hit.p = r.pointAt(t: hit.t)
                hit.normal = (hit.p - center(time: r.time)) / radius
                
                hit.mat = self.mat
                
                //print("sphere hitted (1)!")
                
                return true
            }
            
            temp = (-b + sqrt(discriminant))/a
            
            //print("\(discriminant) -> \(t_min) > \(temp) < \(t_max)")
            
            if (temp < t_max && temp > t_min) {
                
                hit.t = temp
                hit.p = r.pointAt(t: hit.t)
                hit.normal = (hit.p - center(time: r.time)) / radius
                hit.mat = self.mat
                
                //print("sphere hitted (2)!")
                
                return true
            }
        }
        
        return false
    }
    
    
    
    func bounding_box(t0: Double, t1: Double) -> AABB? {
           
        let box0: AABB = AABB(min: center(time: t0) - Vector3(radius, radius, radius), max: center(time: t0) + Vector3(radius, radius, radius))
        
        let box1: AABB = AABB(min: center(time: t1) - Vector3(radius, radius, radius), max: center(time: t1) + Vector3(radius, radius, radius))

        return surrounding_box(box0: box0, box1: box1)
    }
}
