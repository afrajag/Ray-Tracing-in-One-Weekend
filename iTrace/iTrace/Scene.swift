//
//  Scene.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 20/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

struct Scene {
    let width: Int
    let height: Int
    let numSamples: Int

    let world: World

    let camera: Camera
    
    let mode: TraceMode
    
    func render() {
        let renderEngine: Tracing
        
        print("Start tracing in \(mode) mode")
        
        switch mode {
            case .WHITTED_TRACING:
                renderEngine = WhittedTrace()
                renderEngine.render(scene: self)
            
            case .PATH_TRACING:
                renderEngine = PathTrace()
                renderEngine.render(scene: self)
        }
    }
}
