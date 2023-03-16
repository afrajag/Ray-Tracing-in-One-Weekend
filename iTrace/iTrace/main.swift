//
//  main.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 05/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd

func random_whitted_scene() -> World {
    var list = [Object]()
    var lightList = [Light]()
    
    let checked: Texture = CheckedTexture(
        odd: ConstantTexture(color: Vector3(0.2, 0.3, 0.1)),
        even: ConstantTexture(color: Vector3(0.9, 0.9, 0.9))
    )
    
    let groundColor: Texture = ConstantTexture(color: Vector3(0.5, 0.5, 0.5))
    
    list.append(Sphere(cen: Vector3(0,-1000,0), r: 1000, mat: Lambertian(a: groundColor))) // ground

    var spheresList = [Object]()
    
    for a in -7..<7 {
        for b in -7..<7 {
            let center = Vector3(Double(a)+0.9*Double.random(in: 0..<1), 0.2, Double(b)+0.9*Double.random(in: 0..<1))
            
            if (center - Vector3(4, 0.2, 0)).length > 0.9 {
                // diffuse
                let pureColor: Texture = ConstantTexture(color: Vector3(Double.random(in: 0..<1)*Double.random(in: 0..<1), Double.random(in: 0..<1)*Double.random(in: 0..<1), Double.random(in: 0..<1)*Double.random(in: 0..<1)))
                
                spheresList.append(Sphere(cen: center, r: 0.2, mat: Lambertian(a: pureColor)))
            }
        }
    }
    
    let BVHTree = BVHNode(objectList: spheresList, time0: 0.0, time1: 0.0)
    
    print("BVH BB is \(BVHTree.box)")
    
    //list.append(BVHTree)
    
    let sphereColor0: Texture = ConstantTexture(color: Vector3(0.4, 1, 0.1))
    
    let sphereMaterial = Lambertian(a: sphereColor0)
    
    // DARK GRAY
    //sphereMaterial.material_specular = Color(0.2, 0.2, 0.2) // ks
    //sphereMaterial.material_shininess = 10 // alpha (scalar)
    
    //list.append(Sphere(cen: Vector3(0,1,0), r: 1.0, mat: sphereMaterial))
    
    let red: Texture = ConstantTexture(color: Vector3(1, 0, 0))
    
    list.append(Sphere(cen: Vector3(-2.5,1,0), r: 1.0, mat: Lambertian(a: red)))
    
    let blue: Texture = ConstantTexture(color: Vector3(0, 0, 1))
    
    list.append(Sphere(cen: Vector3(2.5,1,0), r: 1.0, mat: Lambertian(a: blue)))
    
    // lights
    let light_material0 = DiffuseLight(a: ConstantTexture(color: Vector3(7, 7, 7)))
    
    light_material0.light_ambient = Color(0.2, 0.2, 0.2) // ia
    light_material0.light_diffuse = Color(0.2, 0.2, 0.2) // id
    light_material0.light_specular = Color(0.2, 0.2, 0.2) // is
    
    /* lookfrom = (0,3,8) - lookat = (0,0,0) */
    
    let light0 = Sphere(cen: Vector3(0,3,0), r: 1, mat: light_material0)
    list.append(light0)
    
    let light0_obj = Light(position: Vector3(-4,3,10), mat: light_material0)
    lightList.append(light0_obj)
    
    let light_material1 = DiffuseLight(a: ConstantTexture(color: Vector3(7,7,7)))
    
    light_material1.light_ambient = Color(0.2, 0.2, 0.2) // ia
    light_material1.light_diffuse = Color(0.5, 0.5, 0.5) // id
    light_material1.light_specular = Color(0.7, 0.7, 0.7) // is
    
    let light1_obj = Sphere(cen: Vector3(20, 15, 20), r: 1, mat: light_material1)
    list.append(light1_obj)
    
    let light1 = Light(position: Vector3(20, 15, 20), mat: light_material1)
    
    lightList.append(light1)
    
    return World(objects: list, lights: lightList)
}

func random_scene() -> World {
    var list = [Object]()
    
    let checked: Texture = CheckedTexture(
        odd: ConstantTexture(color: Vector3(0.2, 0.3, 0.1)),
        even: ConstantTexture(color: Vector3(0.9, 0.9, 0.9))
    )
    
    list.append(Sphere(cen: Vector3(0,-1000,0), r: 1000, mat: Lambertian(a: checked))) // ground

    var spheresList = [Object]()
    
    for a in -7..<7 {
        for b in -7..<7 {
            let choose_mat: Double = Double.random(in: 0..<1)
            
            let center = Vector3(Double(a)+0.9*Double.random(in: 0..<1), 0.2, Double(b)+0.9*Double.random(in: 0..<1))
            
            if (center - Vector3(4, 0.2, 0)).length > 0.9 {
                
                if (choose_mat < 0.8) {
                    // diffuse
                    let pureColor: Texture = ConstantTexture(color: Vector3(Double.random(in: 0..<1)*Double.random(in: 0..<1), Double.random(in: 0..<1)*Double.random(in: 0..<1), Double.random(in: 0..<1)*Double.random(in: 0..<1)))
                    
                    spheresList.append(Sphere(cen: center, r: 0.2, mat: Lambertian(a: pureColor)))
                    //list.append(MovingSphere(cen0: center, cen1: center+Vector3(0, 0.5*Double.random(in: 0..<1), 0), t0: 0.0, t1: 1.0, r: 0.2, mat: Lambertian(albedo: Vector3(Double.random(in: 0..<1)*Double.random(in: 0..<1), Double.random(in: 0..<1)*Double.random(in: 0..<1), Double.random(in: 0..<1)*Double.random(in: 0..<1)))))
                } else if (choose_mat < 0.95) {
                    // metal
                    spheresList.append(Sphere(cen: center, r: 0.2, mat: Metal(albedo: Vector3(0.5*(1 + Double.random(in: 0..<1)), 0.5*(1 + Double.random(in: 0..<1)), 0.5*(1 + Double.random(in: 0..<1))), f: 0.5*Double.random(in: 0..<1))))
                } else {
                    // glass
                    spheresList.append(Sphere(cen: center, r: 0.2, mat: Dielectric(ref_idx: 1.5)))
                }
            }
        }
    }
    
    let BVHTree = BVHNode(objectList: spheresList, time0: 0.0, time1: 0.0)
    
    print("BVH BB is \(BVHTree.box)")
    
    list.append(BVHTree)
    
    list.append(Sphere(cen: Vector3(0,1,0), r: 1.0, mat: Dielectric(ref_idx: 1.5)))
    
    let sphereColor: Texture = ConstantTexture(color: Vector3(0.4, 0.2, 0.1))
    
    list.append(Sphere(cen: Vector3(-4,1,0), r: 1.0, mat: Lambertian(a: sphereColor)))
    list.append(Sphere(cen: Vector3(4,1,0), r: 1.0, mat: Metal(albedo: Vector3(0.7, 0.6, 0.5), f: 0.0)))
    
    return World(objects: list, lights: [])
}

func cornell_scene() -> World {
    var list = [Object]()
    
    let red: Material = Lambertian(a: ConstantTexture(color: Vector3(0.65, 0.05, 0.05)))
    let white: Material = Lambertian(a: ConstantTexture(color: Vector3(0.73, 0.73, 0.73)))
    let green: Material = Lambertian(a: ConstantTexture(color: Vector3(0.12, 0.45, 0.15)))
    let light: Material = DiffuseLight(a: ConstantTexture(color: Vector3(15, 15, 15)))
    
    // cornell box
    list.append(FlipNormals(obj: YZRectangle(y0: 0, y1: 555, z0: 0, z1: 555, k: 555, mat: green)))
    list.append(YZRectangle(y0: 0, y1: 555, z0: 0, z1: 555, k: 0, mat: red))
    list.append(XZRectangle(x0: 213, x1: 343, z0: 227, z1: 332, k: 554, mat: light))
    list.append(FlipNormals(obj: XZRectangle(x0: 0, x1: 555, z0: 0, z1: 555, k: 555, mat: white)))
    list.append(XZRectangle(x0: 0, x1: 555, z0: 0, z1: 555, k: 0, mat: white))
    list.append(FlipNormals(obj: XYRectangle(x0: 0, x1: 555, y0: 0, y1: 555, k: 555, mat: white)))

    // more boxes
    let b1: Object = Translate(obj: YRotate(obj: Box(p0: Vector3(0, 0, 0), p1: Vector3(165, 165, 165), mat: white), angle: -18), displacement: Vector3(130,0,65))
    let b2: Object = Translate(obj: YRotate(obj: Box(p0: Vector3(0, 0, 0), p1: Vector3(165, 330, 165), mat: white), angle: 15), displacement: Vector3(265,0,295))

    list.append(ConstantMedium(obj: b1, d: 0.01, a: ConstantTexture(color: Vector3(1,1,1))))
    list.append(ConstantMedium(obj: b2, d: 0.01, a: ConstantTexture(color: Vector3(0,0,0))))

    return World(objects: list, lights: [])
}


func test_scene() -> World {
    var list = [Object]()
    
    let noise: Texture = NoiseTexture(noise: Perlin(), scale: 4.0)
    
    //let imageTexture = ImageTexture(path: "/Users/afrajag/Desktop/earthmap.jpg")

    list.append(Sphere(cen: Vector3(0,-1000, 0), r: 1000, mat: Lambertian(a: noise))) // ground
    list.append(Sphere(cen: Vector3(0, 2, 0), r: 2, mat: Lambertian(a: noise)))
    
    list.append(Sphere(cen: Vector3(0, 7, 0), r: 2, mat: DiffuseLight(a: ConstantTexture(color: Vector3(4,4,4)))))
    list.append(XYRectangle(x0: 3, x1: 5, y0: 1, y1: 3, k: -2, mat: DiffuseLight(a: ConstantTexture(color: Vector3(4,4,4)))))

    return World(objects: list, lights: [])
}

func final_scene() -> World {
    var list = [Object]()
    var boxList = [Object]()
    var boxList2 = [Object]()
    
    let ground: Material = Lambertian(a: ConstantTexture(color: Vector3(0.48, 0.83, 0.53)))
    let white: Material = Lambertian(a: ConstantTexture(color: Vector3(0.73, 0.73, 0.73)))
    
    for i in 0..<20 {
        for j in 0..<20 {
            let w: Double = 100
            let x0: Double = -1000 + Double(i)*w
            let z0: Double = -1000 + Double(j)*w
            let y0: Double = 0
            let x1: Double = x0 + w
            let y1: Double = 100*(Double.random(in: 0..<1)+0.01)
            let z1: Double = z0 + w
            
            boxList.append(Box(p0: Vector3(x0,y0,z0), p1: Vector3(x1,y1,z1), mat: ground))
        }
    }
    
    let BVHTree = BVHNode(objectList: boxList, time0: 0.0, time1: 1.0)
    list.append(BVHTree)
    
    let light: Material = DiffuseLight(a: ConstantTexture(color: Vector3(7, 7, 7)))
    
    list.append(XZRectangle(x0: 123, x1: 423, z0: 147, z1: 554, k: 0, mat: light))
    
    let center = Vector3(400, 400, 200)

    list.append(MovingSphere(cen0: center, cen1: center+Vector3(30,0,0), t0: 0.0, t1: 1.0, r: 50, mat: Lambertian(a: ConstantTexture(color: Vector3(0.7, 0.3, 0.1)))))
    
    list.append(Sphere(cen: Vector3(260, 150, 45), r: 50, mat: Dielectric(ref_idx: 1.5)))
    list.append(Sphere(cen: Vector3(0, 150, 145), r: 50, mat: Metal(albedo: Vector3(0.8, 0.8, 0.9), f: 10.0)))
    
    let boundary = Sphere(cen: Vector3(360, 150, 145), r: 70, mat: Dielectric(ref_idx: 1.5))
    
    list.append(boundary)
    
    list.append(ConstantMedium(obj: boundary, d: 0.2, a: ConstantTexture(color: Vector3(0.2, 0.4, 0.9))))
    
    let boundary_2 = Sphere(cen: Vector3(0,0,0), r: 5000, mat: Dielectric(ref_idx: 1.5))
    
    list.append(ConstantMedium(obj: boundary_2, d: 0.0001, a: ConstantTexture(color: Vector3(1.0, 1.0, 1.0))))
    
    let imageTexture = ImageTexture(path: "/Users/afrajag/Desktop/earthmap.jpg")
    
    let imageMaterial: Material = Lambertian(a: imageTexture)
    
    list.append(Sphere(cen: Vector3(400, 200, 400), r: 100, mat: imageMaterial))
    
    let noise: Texture = NoiseTexture(noise: Perlin(), scale: 0.1)
    
    list.append(Sphere(cen: Vector3(220, 280, 300), r: 80, mat: Lambertian(a: noise)))
    
    for _ in 0..<1000 {
        boxList2.append(Sphere(cen: Vector3(165*Double.random(in: 0..<1), 165*Double.random(in: 0..<1), 165*Double.random(in: 0..<1)), r: 10, mat: white))
    }
    
    list.append(Translate(obj: YRotate(obj: BVHNode(objectList: boxList2, time0: 0.0, time1: 1.0), angle: 15), displacement: Vector3(-100,270,395)))

    return World(objects: list, lights: [])
}

func whitted_scene() -> World {
    var objectList = [Object]()
    var lightList = [Light]()
    
    //let noise: Texture = NoiseTexture(noise: Perlin(), scale: 0.1)
    //list.append(Sphere(cen: Vector3(0,-1000,0), r: 1000, mat: Lambertian(a: noise))) // ground

    let ground: Texture = ConstantTexture(color: Vector3(0.6, 0.7, 0.8))
    
    objectList.append(Sphere(cen: Vector3(0,-1000,0), r: 1000, mat: Lambertian(a: ground)))

    let red: Texture = ConstantTexture(color: Vector3(1, 0, 0))
    objectList.append(Sphere(cen: Vector3(0.60, 0.5, -3.10), r: 0.5, mat: Lambertian(a: red)))
    
    let green: Texture = ConstantTexture(color: Vector3(0, 1, 0))
    objectList.append(Sphere(cen: Vector3(-0.65, 0.5, -2.75), r: 0.5, mat: Lambertian(a: green)))
    
    let light: Material = DiffuseLight(a: ConstantTexture(color: Vector3(7, 7, 7)))
    
    lightList.append(Light(position: Vector3(10, 10, 10), mat: light))
    
    return World(objects: objectList, lights: lightList)
}

print("Starting iTrace...")

print("Init world")

/*
// random_scene
let world: World = random_scene()
 
let lookfrom = Vector3(13,3,3)
let lookat = Vector3(0,0,0)
let aperture: Double = 0.0
let focus_dist: Double = (lookfrom-lookat).length
*/
/*
// test_scene
let world: World = test_scene()

let lookfrom = Vector3(13,2,3)
let lookat = Vector3(0,0,0)
let aperture: Double = 0.0
let focus_dist: Double = 10
*/


// cornell_scene
let world: World = cornell_scene()

let lookfrom = Vector3(278, 278, -800)
let lookat = Vector3(278,278,0)
let aperture: Double = 0.0
let focus_dist: Double = 10


/*
// final_scene
let world: World = final_scene()

let lookfrom = Vector3(278, 278, -800)
let lookat = Vector3(278,278,0)
let aperture: Double = 0.0
let focus_dist: Double = 10

let width: Int = 160
let height: Int = 120
let numSamples: Int = 10 // path tracing
*/

/*
// WHITTED
let world: World = whitted_scene()

let lookfrom = Vector3(0, 0.75, 0)
let lookat = Vector3(0, 0.5, -1)
let aperture: Double = 0.0
let focus_dist: Double = 1.73 //(lookfrom-lookat).length
*/

/*
// random_whitted_scene
let world: World = random_whitted_scene()
 
let lookfrom = Vector3(0,3,8)
let lookat = Vector3(0,0,0)
let aperture: Double = 0.0
let focus_dist: Double = (lookfrom-lookat).length
*/
log("Focal lenght: \(focus_dist)")

let width: Int = 500
let height: Int = 500
let numSamples: Int = 10

print("Init camera")

let camera = Camera(lookfrom: lookfrom, lookat: lookat, vup: Vector3(0,1,0), vfov: 40, aspect: Double(width)/Double(height), aperture: aperture, focus_dist: focus_dist, t0: 0.0, t1: 1.0)

print("Init scene")
print("Image size: \(width)x\(height)")
print("Num. samples \(numSamples)")

let scene = Scene(width: width, height: height, numSamples: numSamples, world: world, camera: camera, mode: .PATH_TRACING)

scene.render()

print("Done.")
