//
//  BVHNode.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 11/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

class BVHNode: Object {

    let left: Object
    let right: Object
    var box: AABB
    
    init(objectList: [Object], time0: Double, time1: Double) {

        //print("List size is \(objectList.count)")
        
        let axis: Int = Int(3*Double.random(in: 0..<1))
        
        var sortedList: [Object]
        
        switch axis {
            
            case 0:
                sortedList = objectList.sorted(by: { (a, b) -> Bool in
                    
                    let box_left = a.bounding_box(t0: 0, t1: 0)
                    let box_right = b.bounding_box(t0: 0, t1: 0)

                    if (box_left!.min.x - box_right!.min.x < 0.0) {
                        
                        return true
                    }

                    return false
                })
                
            case 1:
                sortedList = objectList.sorted(by: { (a, b) -> Bool in
                    
                    let box_left = a.bounding_box(t0: 0, t1: 0)
                    let box_right = b.bounding_box(t0: 0, t1: 0)

                    if (box_left!.min.y - box_right!.min.y < 0.0) {
                        
                        return true
                    }

                    return false
                })
            
            default:
                sortedList = objectList.sorted(by: { (a, b) -> Bool in
                    
                    let box_left = a.bounding_box(t0: 0, t1: 0)
                    let box_right = b.bounding_box(t0: 0, t1: 0)

                    if (box_left!.min.z - box_right!.min.z < 0.0) {
                        
                        return true
                    }

                    return false
                })
        }

        let count = sortedList.count
        
        if (count == 1) {
            
            //print("Leaf (one child)")
            
            left = sortedList[0]
            right = sortedList[0]
        }
        else if (count == 2) {
            
            //print("Leaf")
            
            left = sortedList[0]
            right = sortedList[1]
        } else {
            
            //print("Splitting into 2 sublist")
            
            let midpoint: Int = sortedList.count / 2
            
            let leftObjects = sortedList[..<midpoint]
            let rightObjects = sortedList[midpoint...]
            
            left = BVHNode(objectList: Array(leftObjects), time0: time0, time1: time1)
            
            right = BVHNode(objectList: Array(rightObjects), time0: time0, time1: time1)
        }

        let box_left = left.bounding_box(t0: time0, t1: time1)
        let box_right = right.bounding_box(t0: time0, t1: time1)

        /*
        if (!left_bb || !right_bb) {

            print("no bounding box in bvh_node constructor\n")
        }
        */
        
        box = surrounding_box(box0: box_left!, box1: box_right!)
        
        //print("Bounding box in bvh_node constructor is \(box)\n")
    }
    
    func hit(r: Ray, t_min: Double, t_max: Double, hit: inout HitRecord) -> Bool {
        //print("Hitting BVH...")
        
        if (box.hit(r: r, t_min: t_min, t_max: t_max)) {
            //print("Hit BVH BB !")
            
            var left_hit = HitRecord(t: 0.0, p: Vector3.Dummy, normal: Vector3.Dummy, mat: Lambertian(a: ConstantTexture(color: Vector3.Dummy)), u: 0.0, v: 0.0)
            var right_hit = HitRecord(t: 0.0, p: Vector3.Dummy, normal: Vector3.Dummy, mat: Lambertian(a: ConstantTexture(color: Vector3.Dummy)), u: 0.0, v: 0.0)
            
            let hit_left: Bool = left.hit(r: r, t_min: t_min, t_max: t_max, hit: &left_hit)
            
            let hit_right: Bool = right.hit(r: r, t_min: t_min, t_max: t_max, hit: &right_hit)
            
            if (hit_left && hit_right) {
                if (left_hit.t < right_hit.t) {
                    hit = left_hit
                    
                    //print("Going left...")
                }
                else {
                    hit = right_hit
                    
                    //print("Going right...")
                }
             
                return true
            }
            else if (hit_left) {
                hit = left_hit
                
                //print("Left hit !")
                
                return true
            }
            else if (hit_right) {
                hit = right_hit
                
                //print("Right hit !")
                
                return true
            }
            else {
                //print("Missed BVH bounding box (LEAF) !")
                
                return false
            }
        }
        else {
            //print("Missed BVH bounding box !")
            
            return false
        }
    }
    
    func bounding_box(t0: Double, t1: Double) -> AABB? {

        return box
    }
}
