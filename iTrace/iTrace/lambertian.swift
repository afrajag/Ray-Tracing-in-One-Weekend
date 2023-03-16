//
//  Lambertian.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 06/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation
import simd
import Accelerate

class Lambertian: Material {
    let albedo: Texture

    // GRAY
    var material_specular = Color(0.6, 0.6, 0.6) // ks
    var material_shininess: Double = 100 // alpha (scalar)
    
    init (a: Texture) {
        self.albedo = a
    }
    
    func scatter(r_in: Ray, hit: HitRecord, attenuation: inout Vector3, scattered: inout Ray) -> Bool {
        let target: Vector3 = hit.p + hit.normal + random_in_unit_sphere()
        
        scattered = Ray(origin: hit.p, direction: target-hit.p, time: r_in.time)
        
        attenuation = albedo.value(u: hit.u, v: hit.v, p: hit.p)
        
        return true
    }
    
    // PHONG
    func shade(r_in: Ray, hit: HitRecord) -> Color {
        var color = Color.Dummy
        
        var temp_rec = HitRecord(t: 0.0, p: Vector3.Dummy, normal: Vector3.Dummy, mat: Metal(albedo: Vector3.Dummy, f: 1.0), u: 0.0, v: 0.0) // just for init variable

        let material_ambient = albedo.value(u: hit.u, v: hit.v, p: hit.p) // ka
        let material_diffuse = albedo.value(u: hit.u, v: hit.v, p: hit.p) // kd
        
        let material_specular = self.material_specular // ks
        let material_shininess: Double = self.material_shininess // alpha
        
        let N = hit.normal.normalize
        
        let lightList = world.lightList
        
        for light in lightList { // iterate through each light
            let light_position = light.position
            
            let light_ambient = (light.mat as! DiffuseLight).light_ambient // ia
            let light_diffuse = (light.mat as! DiffuseLight).light_diffuse // id
            let light_specular = (light.mat as! DiffuseLight).light_specular // is
            
            // calculate ambient term (ka*ia)
            let ambient_term = material_ambient * light_ambient
            
            // calculate diffuse term (kd*id*(N*L))
            let L = (light_position - hit.p).normalize

            let shadowRay = Ray(origin: hit.p, direction: L, time: r_in.time)
            if world.hit(r: shadowRay, t_min: 0.001, t_max: Double.greatestFiniteMagnitude, hit: &temp_rec) {
                return Color(clamp(ambient_term.model, min: Double(0.0), max: Double(1.0)))
            }
            
            let diffuse_term = material_diffuse * (light_diffuse * max(0, (N • L)))
            
            // calculate specular term (kd*id*(N*L))
            let R = reflect(v: L, n: N)
            
            let V = (hit.p - r_in.origin).normalize
            
            let ks_is = material_specular * light_specular
            
            let specular_term = ks_is * pow(max(0, (V • R)), material_shininess)
            
            // resulting color
            color += ambient_term + diffuse_term + specular_term
        }
        /*
        if ((color.r > 1 || color.r < 0) || (color.g > 1 || color.g < 0) || (color.b > 1 || color.b < 0)) {
            log("Color --> \(color)")
        }
        */
        color = Color(clamp(color.model, min: Double(0.0), max: Double(1.0)))
        
        return color
    }
    
    func shade1(r_in: Ray, hit: HitRecord) -> Color {
        let light_position = Vector3(100, 100, -50)
        
        let L = (light_position - hit.p).normalize
        let shadowRay = Ray(origin: hit.p, direction: L, time: r_in.time)
               
        var temp_rec = HitRecord(t: 0.0, p: Vector3.Dummy, normal: Vector3.Dummy, mat: Metal(albedo: Vector3.Dummy, f: 1.0), u: 0.0, v: 0.0) // just for init variable
        // is the point in shadow, and is the nearest occluding object closer to the object than the light itself?
        let inShadow: Bool = world.hit(r: shadowRay, t_min: 0.001, t_max: Double.greatestFiniteMagnitude, hit: &temp_rec)

        if (inShadow) {
           return Color.Dummy
        }
        
        return albedo.value(u: hit.u, v: hit.v, p: hit.p)
    }
    
    func shade0(r_in: Ray, hit: HitRecord) -> Color {
        var temp_rec = HitRecord(t: 0.0, p: Vector3.Dummy, normal: Vector3.Dummy, mat: Metal(albedo: Vector3.Dummy, f: 1.0), u: 0.0, v: 0.0) // just for init variable

        let light_position = Vector3(30, 30, 30)
        let light_color = Color(1,1,1)
        
        let ambient = albedo.value(u: hit.u, v: hit.v, p: hit.p)
        let diffuse = albedo.value(u: hit.u, v: hit.v, p: hit.p)
        let specular = Color(0.05,0.05,0.05)
        let shininess: Double = 1
        
        // Loop over all lights in the scene and sum their contribution up
        // We also apply the lambert cosine law here though we haven't explained yet what this means.
        /*
             The Phong approximation of real-world reflectance calculates the color of a point on a surface using the following formula:

             color = ambient * al + diffuse * max(0, dot(N, L)) + specular * pow(max(0, dot(R, E)), shininess)
         
             al
             The sum of all ambient lights in the scene (a color).

             N
             The surface normal vector at the point being shaded, as supplied by the geometry’s vertex data, interpolated between vertices, and possibly modified by the material’s normal property.

             L
             The (normalized) vector from the point being shaded to the light source.

             E
             The (normalized) vector from the point being shaded to the viewer.

             R
             The reflection of the light vector L across the normal vector N.
        */
        
        let N = hit.normal.normalize

        let L = (light_position - hit.p).normalize
        
        let shadowRay = Ray(origin: hit.p, direction: L, time: r_in.time)
        
        // is the point in shadow, and is the nearest occluding object closer to the object than the light itself?
        let inShadow: Bool = world.hit(r: shadowRay, t_min: 0.001, t_max: Double.greatestFiniteMagnitude, hit: &temp_rec)

        if (inShadow) {
            return Color.Dummy
        }
        
        let al = light_color
        
        let E = (r_in.origin - hit.p).normalize

        let R = reflect(v: L, n: N)
        
        //if (N • L) < 0 { log("N*L = \(N • L)") }
        
        let ambient_component = ambient * al
        let diffuse_component = diffuse * max(0, (N • L))
        let specular_component = specular * pow(max(0, (R • E)), shininess)
        
        //print("[\(ambient_component) , \(diffuse_component) , \(specular_component)] --> \(ambient_component + diffuse_component + specular_component)")
        
        return ambient_component + diffuse_component + specular_component
    }
    
    func shade3(r_in: Ray, hit: HitRecord) -> Color {
        // We use the Phong illumation model int the default case. The phong model
        // is composed of a diffuse and a specular reflection component.
        /*
         Vec3f hitPoint = orig + dir * tnear;
         Vec3f N; // normal
         Vec2f st; // st coordinates
         */
        let dir = hit.p
        let N = hit.normal
        let hitPoint = hit.p
        let light_position = Vector3(100, 100, -50)
        let light_intensity: Double = 0.5
        let bias: Double = 0.00001
        var lightAmt = Color.Dummy
        var specularColor = Color.Dummy
        let shadowPointOrig: Vector3 = dir • N < 0 ? hitPoint + N * bias : hitPoint - N * bias

        let hitObject_specularExponent: Double = 1.0
        let hitObject_Kd: Double = 1.0
        let hitObject_Ks: Double = 0.5
        
        // Loop over all lights in the scene and sum their contribution up
        // We also apply the lambert cosine law here though we haven't explained yet what this means.
        var lightDir: Vector3 = light_position - hitPoint
        
        // square of the distance between hitPoint and the light
        let lightDistance2: Double = lightDir • lightDir
        lightDir = lightDir.normalize
        let LdotN: Double = max(0.0, lightDir • N)
        
        //Object *shadowHitObject = nullptr;
        let tNearShadow: Double = Double.greatestFiniteMagnitude
        
        // is the point in shadow, and is the nearest occluding object closer to the object than the light itself?
        //bool inShadow = trace(shadowPointOrig, lightDir, objects, tNearShadow, index, uv, &shadowHitObject) && tNearShadow * tNearShadow < lightDistance2
        var temp_rec = HitRecord(t: 0.0, p: Vector3.Dummy, normal: Vector3.Dummy, mat: Metal(albedo: Vector3.Dummy, f: 1.0), u: 0.0, v: 0.0) // just for init variable
        let shadowRay = Ray(origin: hit.p, direction: light_position, time: r_in.time)
        let inShadow: Bool = world.hit(r: shadowRay, t_min: 0.001, t_max: Double.greatestFiniteMagnitude, hit: &temp_rec) && tNearShadow * tNearShadow < lightDistance2
        /*
        if (inShadow) {
            return Color.Dummy
        }
        */
        lightAmt += (1 - (inShadow ? 1 : 0)) * light_intensity * LdotN
        
        let reflectionDirection: Vector3 = reflect(v: -lightDir, n: N)
        
        specularColor += pow(max(0.0, -(reflectionDirection • dir)), hitObject_specularExponent) * light_intensity
        
        let diffuse_color = hitObject_evalDiffuseColor()
        let hitColor = lightAmt + diffuse_color * hitObject_Kd + specularColor * hitObject_Ks
        
        return hitColor
    }
    
    func hitObject_evalDiffuseColor() -> Vector3
    {
        let scale: Double = 5.0
        let pattern: Double = 0.5 //(fmodf(st.x * scale, 1.0) > 0.5 ? 1.0 : 0.0) ^ (fmodf(st.y * scale, 1.0) > 0.5 ? 1.0 : 0.0)
        
        let vectorA: [Double] = [0.815, 0.235, 0.031]
        let vectorB: [Double] = [0.937, 0.937, 0.231]
        
        let result = vDSP.linearInterpolate(vectorA, vectorB, using: 0.5)
        
        return Vector3(result[0], result[1], result[2])
    }
    
    /*
    func _shade3(r_in: Ray, hit: HitRecord) -> Color {
        double kd
        
        public Phong(Texture a, double k_d){
            albedo = a;
            kd = k_d;
        }

        public double scatteringPDF(Ray r_in, HitRecord rec, Ray scattered){
            double cosine = Vec3.dot(hit.normal, Vec3.unit_vector(scattered.direction()));
            if(cosine < 0) cosine = 0; //if not in hemisphere
            return cosine/Math.PI; //probability of direction follows cosine law
        }

        public boolean scatter(Ray r_in, HitRecord rec, ScatterRecord srec){
            if(Math.random() < kd){
                shit.is_specular = 0;
                shit.attenuation = albedo.value(hit.u, hit.v, hit.p);
                shit.pdf = new CosinePDF(hit.normal);
            } else {
                PDF p = new ConstantHemispherePDF(hit.normal);
                Vec3 reflected = p.generate();
                shit.is_specular = 1;
                shit.specular_ray = new Ray(hit.p, reflected);
                shit.attenuation = new Vec3(Math.pow(Math.max(0,Vec3.dot(hit.normal, reflected)), 50));
            }
            return true;
        }
    }
    */
}
