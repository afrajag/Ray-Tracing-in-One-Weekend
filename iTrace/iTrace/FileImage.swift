//
//  FileImage.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 08/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

class Image {

    let width: Int
    let height: Int
    var data: Data
    
    let outPath: String
    
    init(width: Int, height: Int, path: String = "image.ppm") {
        
        self.width = width
        self.height = height
        
        self.outPath = path
        
        data = Data()
        
        let header = "P3\n\(width) \(height)\n255\n".data(using: .ascii)!
        data.append(header)
    }

    func addPixel(pixel: Color) {
        
        //print("\(pixel.x) \(pixel.y) \(pixel.z)\n")
        
        let ir: Int = Int(255.99*pixel.x)
        let ig: Int = Int(255.99*pixel.y)
        let ib: Int = Int(255.99*pixel.z)
        
        let pixel_ascii = "\(ir) \(ig) \(ib)\n".data(using: .ascii)!
        data.append(pixel_ascii)
    }
    
    func save() {
        
        print("Saving image to \(outPath)")
        
        print ("image: \(data)")

        let fileSaved = FileManager.default.createFile(atPath: outPath, contents: data)

        if !fileSaved {
            print ("ERROR: image not saved !")
        }
    }
}
