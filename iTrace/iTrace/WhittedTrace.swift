//
//  WhittedTracing.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 24/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

struct WhittedTrace : Tracing {
    func render(scene: Scene) {
        let start = DispatchTime.now() // <<<<<<<<<< Start time

        var pixels = Array<Color>(repeating: Color.Dummy, count: scene.width*scene.height)

        // Initiate multithreading
        DispatchQueue.concurrentPerform(iterations: scene.height) { y in
        //for y in 0..<scene.height {
            if (y%10 == 0) { print("\tRendering line \(y)") }
            
            for x in 0..<scene.width {
                var pixel = Color.Dummy
                
                if scene.numSamples < 2 {
                    let u = Double(x) / Double(scene.width)
                    let v = Double(y) / Double(scene.height)
                    
                    let r = scene.camera.get_whitted_ray(s: u, t: v)
                    
                    pixel += trace(r: r, world: scene.world)
                    
                } else {
                    for _ in 0..<scene.numSamples {
                    
                        let u = Double(Double(x) + Double.random(in: 0..<1)) / Double(scene.width)
                        let v = Double(Double(y) + Double.random(in: 0..<1)) / Double(scene.height)
                        
                        let r = scene.camera.get_whitted_ray(s: u, t: v)
                        
                        pixel += trace(r: r, world: scene.world)
                    }
                    
                    pixel /= Double(scene.numSamples)
                }

                // gamma correction 2.0 (with sqrt)
                pixel = Color(sqrt(pixel.x), sqrt(pixel.y), sqrt(pixel.z))

                let index = (scene.height-y-1)*scene.width+x

                pixels[index] = pixel
            }
        }

        print("End tracing")

        let image = Image(width: scene.width, height: scene.height)
        
        for i in 0..<scene.width*scene.height {
            image.addPixel(pixel: pixels[i])
        }
        
        image.save()
        
        let end = DispatchTime.now()   // <<<<<<<<<<   end time

        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
        let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

        print("Finished tracing in \(timeInterval) seconds")
    }

    func trace(r: Ray, world: Object) -> Color {
        var hit = HitRecord(t: 0.0, p: Vector3(0,0,0), normal: Vector3(0,0,0), mat: Metal(albedo: Vector3(0.0, 0.0, 0.0), f: 1.0), u: 0.0, v: 0.0)
        
        if (world.hit(r: r, t_min: 0.001, t_max: Double.greatestFiniteMagnitude, hit: &hit)) {
            let shading_color = hit.mat.shade(r_in: r, hit: hit)
            
            return shading_color
        } else {
            return sky(r: r)
        }
    }
}
