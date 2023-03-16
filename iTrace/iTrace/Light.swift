//
//  Light.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 04/02/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

class Light {
    let position: Vector3
    var mat: Material
    
    init(position: Vector3, mat: Material) {
        self.position = position
        self.mat = mat
    }
}
