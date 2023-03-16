//
//  Trace.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 24/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import Foundation

enum TraceMode {
    case WHITTED_TRACING
    case PATH_TRACING
}

protocol Tracing {
    func render(scene: Scene)
}

func sky(r: Ray) -> Color {
    let unit_direction: Vector3 = r.direction.normalize
    let t: Double = 0.5*(unit_direction.y + 1.0)

    return (1.0-t)*Color(1.0, 1.0, 1.0) + t*Color(0.235294, 0.67451, 0.843137)
}
