//
//  hittable.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 05/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

protocol Object {
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool
    
    func bounding_box(t0: Double, t1: Double) -> AABB?
}
