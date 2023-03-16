//
//  ImageTexture.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 19/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Cocoa

class ImageTexture : Texture {
    let image: NSImage
    let pixelData: [Pixel]
    
    var width: Int {
        get {
            return image.representations[0].pixelsWide
        }
    }
    
    var height: Int {
        get {
            return image.representations[0].pixelsHigh
        }
    }
    
    init(path: String) {
        // /Users/afrajag/Desktop/earthmap.jpg
        
        image = NSImage(contentsOfFile: path)!
        
        pixelData = image.pixelData()
        
        print("Loading image texture \(path) - size: \(image.representations[0].pixelsWide)x\(image.representations[0].pixelsHigh)")
        
        /*
        let image = Image(width: width, height: height, path: "earth.ppm")
        
        for pixel in pixelData {
            
            image.addPixel(pixel: pixel.color)
        }
        
        image.save()
        */
    }

    func value(u: Double, v: Double, p: Vector3) -> Vector3 {
        let x = Int(u * Double(width))
        let y = Int((1.0 - v) * Double(height))

        let offset = (y * width + x) - 1
        
        let pixel = pixelData[offset]
        
        return pixel.color
    }
}

extension NSImage {
    func pixelData() -> [Pixel] {
        let bmp = self.representations[0] as! NSBitmapImageRep
        var data: UnsafeMutablePointer<UInt8> = bmp.bitmapData!
        var r, g, b, a: UInt8
        var pixels: [Pixel] = []

        for row in 0..<bmp.pixelsHigh {
            for col in 0..<bmp.pixelsWide {
                r = data.pointee
                data = data.advanced(by: 1)
                g = data.pointee
                data = data.advanced(by: 1)
                b = data.pointee
                data = data.advanced(by: 1)
                a = data.pointee
                data = data.advanced(by: 1)
                pixels.append(Pixel(r: r, g: g, b: b, a: a, row: row, col: col))
            }
        }

        return pixels
    }

}

struct Pixel {
    var r: Double
    var g: Double
    var b: Double
    var a: Double
    var row: Int
    var col: Int

    init(r: UInt8, g: UInt8, b: UInt8, a: UInt8, row: Int, col: Int) {
        self.r = Double(r)
        self.g = Double(g)
        self.b = Double(b)
        self.a = Double(a)
        self.row = row
        self.col = col
    }

    var color: Color {
        return Color(r/255.0, g/255.0, b/255.0)
    }

    var description: String {
        return "\(r) \(g) \(b)"
    }
}
