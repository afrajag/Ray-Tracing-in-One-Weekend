//
//  material.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 06/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

protocol Material {
    func scatter(r_in: Ray, hit: HitRecord, attenuation: inout Vector3, scattered: inout Ray) -> Bool
    
    func emitted(u: Double, v: Double, p: Vector3) -> Vector3
    
    func shade(r_in: Ray, hit: HitRecord) -> Color
}

extension Material {
    func scatter(r_in: Ray, hit: HitRecord, attenuation: inout Vector3, scattered: inout Ray) -> Bool {
        return false
    }
    
    func emitted(u: Double, v: Double, p: Vector3) -> Vector3 {
        return Vector3.Dummy
    }
    
    func shade(r_in: Ray, hit: HitRecord) -> Color {
        return Color.Dummy
    }
}

func random_in_unit_sphere() -> Vector3 {
    var p: Vector3
    
    repeat {
        p = 2.0*Vector3(Double.random(in: 0..<1), Double.random(in: 0..<1), Double.random(in: 0..<1)) - Vector3(1,1,1)
    } while p.squaredLength >= 1.0
    
    return p
}

func schlick(cosine: Double, ref_idx: Double) -> Double {
    var r0: Double = (1-ref_idx) / (1+ref_idx)
    r0 = r0*r0
    
    return r0 + (1-r0)*pow((1 - cosine),5)
}

func reflect(v: Vector3, n: Vector3) -> Vector3 {
    return Vector3(simd_reflect(v.model, n.model))
    // return v - 2 * v • n * n
}

func refract(v: Vector3, n: Vector3, niOverNt: Double, refracted: inout Vector3) -> Bool {
    let uv: Vector3 = v.normalize
    let dt: Double = uv • n
    let discriminant: Double = 1.0 - niOverNt * niOverNt * (1 - dt * dt)
    
    if discriminant > 0 {
        refracted = niOverNt * (uv - n * dt) - n * discriminant.squareRoot()
        return true
    }
    
    return false
}
