//
//  World.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 08/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

struct HitRecord {
    var t: Double
    var p :Vector3
    var normal: Vector3
    var mat: Material
    
    var u: Double
    var v: Double
}

class World: Object {
    var list: [Object]
    var lightList: [Light]
    
    init(objects: [Object], lights: [Light]) {
        self.list = objects
        self.lightList = lights
        
        print("Object list size is \(list.count)")
        print("Light list size is \(lightList.count)")
    }
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool {
        
        var temp_hit = HitRecord(t: 0.0, p: Vector3.Dummy, normal: Vector3.Dummy, mat: Metal(albedo: Vector3.Dummy, f: 1.0), u: 0.0, v: 0.0) // just for init variable
        
        var hit_anything: Bool = false
        
        var closest_so_far: Double = Double(t_max)
        
        for object in list  {
            
            if (object.hit(r: r, t_min: t_min, t_max: Double(closest_so_far), hit: &temp_hit)) {
                
                hit_anything = true
                
                closest_so_far = Double(temp_hit.t)
                
                hit = temp_hit
            }
        }
        
        return hit_anything
    }
    
    func bounding_box(t0: Double, t1: Double) -> AABB? {
        
        /*
        if (list.count < 1) {
            
            return false
        }
        
        var temp_box = AABB(min: Vector3.Dummy, max: Vector3.Dummy)
        
        let first_true = list[0].bounding_box(t0: t0, t1: t1, box: &box)
        
        if (!first_true) {
            return false
        } else {
            box = temp_box
        }
        
        for object in list  {
            if (object.bounding_box(t0: t0, t1: t1, box: &temp_box)) {
                box = surrounding_box(box0: box, box1: temp_box)
            } else {
                return false
            }
        }
        
        return true
        */
        
        var result: AABB? = nil
        
        if list.count < 1 {
            return nil
        }
        
        if let tempBox = list[0].bounding_box(t0: t0, t1: t1) {
            result = tempBox
        }
        else {
            return nil
        }
        
        for elem in list {
            if let tempBox = elem.bounding_box(t0: t0, t1: t1) {
                result = surrounding_box(box0: result!, box1: tempBox)
            }
            else {
                return nil
            }
        }
        
        return result
        
    }
}

/*
 class hitable_list : hitable  {
 var members : [hitable] = []
 func add(h : hitable) {
     members.append(h)
 }
 func hit(r : ray, tmin : Double) -> (Bool, Double, vec3) {
     var t_clostest_so_far = 1.0e6 // not defined: Double.max
     var hit_anything : Bool = false
     var new_t : Double
     var hit_it : Bool
     var normal : vec3 = vec3(x:1.0, y:0.0, z:0.0)
     var new_normal : vec3

     for item in members {
         (hit_it , new_t, new_normal) = item.hit(r, tmin: tmin)
         if (hit_it && new_t < t_clostest_so_far) {
             hit_anything = true
             t_clostest_so_far = new_t
             normal = new_normal
         }
     }
     return (hit_anything, t_clostest_so_far, normal)
 }
*/
