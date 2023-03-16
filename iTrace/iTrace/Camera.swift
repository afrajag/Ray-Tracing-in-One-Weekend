//
//  camera.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 06/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

class Camera {
    let origin: Vector3
    let lower_left_corner: Vector3
    let horizontal: Vector3
    let vertical: Vector3
    
    let u: Vector3
    let v: Vector3
    let w: Vector3
    
    let lens_radius: Double
    
    let time0, time1: Double
    
    // vfov is top to bottom in degrees
    init(lookfrom: Vector3, lookat: Vector3, vup: Vector3, vfov: Double, aspect: Double, aperture: Double, focus_dist: Double, t0: Double, t1: Double) {
        time0 = t0
        time1 = t1
        
        let theta: Double = vfov*Double.pi/180 // 1.39 x vfov = 80
        let half_height: Double = tan(theta/2) // 0.83
        let half_width: Double = aspect * half_height // 1.079
        
        origin = lookfrom
        
        w = (lookfrom - lookat).normalize
        u = (vup × w).normalize
        v = (w × u).normalize
        
        lens_radius = aperture / 2

        lower_left_corner = origin - half_width * focus_dist * u - half_height * focus_dist * v - focus_dist * w
        
        horizontal = 2*half_width*focus_dist*u
        vertical = 2*half_height*focus_dist*v
    }
    
    func get_ray(s: Double, t: Double) -> Ray {
        let rd: Vector3 = lens_radius*random_in_unit_disk()
        let offset:Vector3 = u * rd.x + v * rd.y
        
        let appv0: Vector3 = lower_left_corner + s*horizontal + t*vertical
        let appv: Vector3 =  appv0 - origin
        
        let time: Double = time0 + Double.random(in: 0..<1)*(time1-time0)
        
        return Ray(origin: origin + offset, direction: appv - offset, time: time)
    }
    
    func get_whitted_ray(s: Double, t: Double) -> Ray {
        let time: Double = 0.0
        
        //log("Direction: \(lower_left_corner + s*horizontal + t*vertical - origin)")
        
        return Ray(origin: origin, direction: lower_left_corner + s*horizontal + t*vertical - origin, time: time)
    }
    
    func random_in_unit_disk() -> Vector3 {
        var p: Vector3
       
        repeat {
            p = 2.0*Vector3(Double.random(in: 0..<1),Double.random(in: 0..<1),0) - Vector3(1,1,0)
        } while (p • p) >= 1.0
        
        return p
    }
}
