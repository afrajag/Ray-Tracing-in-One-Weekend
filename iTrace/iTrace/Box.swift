//
//  Box.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 20/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

class Box: Object {
    let p_min, p_max: Vector3
    var objList: World

    init(p0: Vector3, p1: Vector3, mat: Material) {
        self.p_min = p0
        self.p_max = p1

        var list = [Object]()
        
        list.append(XYRectangle(x0: p0.x, x1: p1.x, y0: p0.y, y1: p1.y, k: p1.z, mat: mat))
        list.append(FlipNormals(obj: XYRectangle(x0: p0.x, x1: p1.x, y0: p0.y, y1: p1.y, k: p0.z, mat: mat)))
        
        list.append(XZRectangle(x0: p0.x, x1: p1.x, z0: p0.z, z1: p1.z, k: p1.y, mat: mat))
        list.append(FlipNormals(obj: XZRectangle(x0: p0.x, x1: p1.x, z0: p0.z, z1: p1.z, k: p0.y, mat: mat)))
        
        list.append(YZRectangle(y0: p0.y, y1: p1.y, z0: p0.z, z1: p1.z, k: p1.x, mat: mat))
        list.append(FlipNormals(obj: YZRectangle(y0: p0.y, y1: p1.y, z0: p0.z, z1: p1.z, k: p0.x, mat: mat)))
        
        objList = World(objects: list, lights: [])
    }
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool {
        return objList.hit(r: r, t_min: t_min, t_max: t_max, hit: &hit)
    }
    
    func bounding_box(t0: Double, t1: Double) -> AABB? {
        return AABB(min: p_min, max: p_max)
    }
}
