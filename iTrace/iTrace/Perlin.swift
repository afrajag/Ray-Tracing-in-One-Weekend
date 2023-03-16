//
//  Perlin.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 19/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

class Perlin {
    
    let ranDouble: [Vector3]
    let perm_x: [Int]
    let perm_y: [Int]
    let perm_z: [Int]
    
    init() {
        
        print("Initializing Perlin noise generator...")
        
        ranDouble = perlin_generate()
        
        perm_x = perlin_generate_perm()
        perm_y = perlin_generate_perm()
        perm_z = perlin_generate_perm()
    }
    
    func noise(p: Vector3) -> Double {
       
        var u: Double = p.x - floor(p.x)
        var v: Double = p.y - floor(p.y)
        var w: Double = p.z - floor(p.z)
        
        u = u*u*(3-2*u)
        v = v*v*(3-2*v)
        w = w*w*(3-2*w)
        
        let i: Int = Int(floor(p.x))
        let j: Int = Int(floor(p.y))
        let k: Int = Int(floor(p.z))
        
        var c = Array(repeating: Array(repeating: Array(repeating: Vector3.Dummy, count: 2), count: 2), count: 2)
        
        for di in 0..<2 {
            for dj in 0..<2 {
                for dk in 0..<2 {
                    c[di][dj][dk] = ranDouble[perm_x[(i+di)&255] ^ perm_y[(j+dj)&255] ^ perm_z[(k+dk)&255]]
                }
            }
        }
        
        //print("Accessing array index [\(i),\(j),\(k)]")
        
        return perlinInterp(c: c, u, v, w)
    }
    
    func turbulence(p: Vector3, depth: Int) -> Double {
        
        var accum: Double = 0.0
        var temp = p
        var weight: Double = 1.0
        
        for _ in 0..<depth {
            accum += weight * noise(p: temp)
            weight *= 0.5
            temp = temp * 2
        }
        
        return abs(accum)
    }
}

func perlin_generate() -> [Vector3] {
    
    var vectors = Array(repeating: Vector3.Dummy, count: 256)
    
    for i in 0..<vectors.count {
        let vector = Vector3(-1 + 2 * Double.random(in: 0..<1), -1 + 2 * Double.random(in: 0..<1), -1 + 2 * Double.random(in: 0..<1))
        
        vectors[i] = vector.normalize
    }
    
    return vectors
}

func perlin_generate_perm() -> [Int] {
    
    var ints = Array(repeating: 0, count: 256)
    
    for i in 0..<ints.count {
        ints[i] = i
    }
    
    for i in (1...ints.count-1).reversed() {
        let target = Int(Double.random(in: 0..<1) * Double(i + 1))
        let temp = ints[i]
        
        ints[i] = ints[target]
        ints[target] = temp
    }
    
    return ints
}

func perlinInterp(c: [[[Vector3]]], _ u: Double, _ v: Double, _ w: Double) -> Double {
    
    let uu = u*u*(3-2*u)
    let vv = v*v*(3-2*v)
    let ww = w*w*(3-2*w)
    
    var accum: Double = 0.0
    
    for i in 0..<2 {
        let ii = Double(i)
        
        for j in 0..<2 {
            let jj = Double(j)
            
            for k in 0..<2 {
                let kk = Double(k)
                let weight = Vector3(u-ii, v-jj, w-kk)
                
                let accu_i = (ii * uu + (1.0 - ii) * (1.0 - uu))
                let accu_j = (jj * vv + (1.0 - jj) * (1.0 - vv))
                let accu_k = (kk * ww + (1.0 - kk) * (1.0 - ww))
                
                accum +=
                    accu_i *
                    accu_j *
                    accu_k *
                    (c[i][j][k] • weight)
            }
        }
    }
    
    return accum
}
