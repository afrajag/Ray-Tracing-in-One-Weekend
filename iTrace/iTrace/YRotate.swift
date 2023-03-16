//
//  YRotate.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 20/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

class YRotate: Object {
    let sinTheta: Double
    let cosTheta: Double
    let hasbox: Bool
    var bbox: AABB
    let obj: Object
    
    init(obj: Object, angle: Double) {
        self.obj = obj
        
        let radians: Double = (Double.pi / 180.0) * angle
        
        sinTheta = sin(radians)
        cosTheta = cos(radians)
        
        if let app_bbox = obj.bounding_box(t0: 0, t1: 1)  {
            bbox = app_bbox
            hasbox = true
        } else {
            bbox = AABB(min: Vector3.Dummy, max: Vector3.Dummy)
            hasbox = false
        }
        
        let min: Vector3 = Vector3(Double.greatestFiniteMagnitude, Double.greatestFiniteMagnitude, Double.greatestFiniteMagnitude)
        var max: Vector3 = Vector3(-Double.greatestFiniteMagnitude, -Double.greatestFiniteMagnitude, -Double.greatestFiniteMagnitude)
        
        for i in stride(from: 0.0, to: 2.0, by: 1.0) {
            for j in stride(from: 0.0, to: 2.0, by: 1.0) {
                for k in stride(from: 0.0, to: 2.0, by: 1.0) {
                    let tmp_x = bbox.max.x + (1.0 - Double(i)) * bbox.min.x
                    let tmp_y = bbox.max.y + (1.0 - Double(j)) * bbox.min.y
                    let tmp_z = bbox.max.z + (1.0 - Double(k)) * bbox.min.z
                    
                    let x = Double(i) * tmp_x
                    let y = Double(j) * tmp_y
                    let z = Double(k) * tmp_z
                    let newX = cosTheta * x + sinTheta * z
                    let newZ = -sinTheta * x + cosTheta * z
                    let tester = Vector3(newX, y, newZ)
                    
                    if tester.x > max.x {
                        max.x = tester.x
                    }
                    
                    if tester.y > max.y {
                        max.y = tester.y
                    }
                    
                    if tester.z > max.z {
                        max.z = tester.z
                    }
                }
            }
        }
         
        bbox = AABB(min: min, max: max)
    }
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool {
        var origin = r.origin
        var direction = r.direction
        
        origin.x = cosTheta * r.origin[0] - sinTheta * r.origin[2]
        origin.z = sinTheta * r.origin[0] + cosTheta * r.origin[2]
        direction.x = cosTheta * r.direction[0] - sinTheta * r.direction[2]
        direction.z = sinTheta * r.direction[0] + cosTheta * r.direction[2]
        
        let rotatedR = Ray(origin: origin, direction: direction, time: r.time)
        
        if obj.hit(r: rotatedR, t_min: t_min, t_max: t_max, hit: &hit) {
            var p = hit.p
            var normal = hit.normal
            
            p.x = cosTheta * hit.p.x + sinTheta * hit.p.z
            p.z = -sinTheta * hit.p.x + cosTheta * hit.p.z
            normal.x = cosTheta * hit.normal.x + sinTheta * hit.normal.z
            normal.z = -sinTheta * hit.normal.x + cosTheta * hit.normal.z
            
            hit.p = p
            hit.normal = normal
            
            return true
        }
        
        return false
    }
    
    func bounding_box(t0: Double, t1: Double) -> AABB? {
        if hasbox {
            return bbox
        }
        
        return AABB(min: Vector3.Dummy, max: Vector3.Dummy)
    }
}
