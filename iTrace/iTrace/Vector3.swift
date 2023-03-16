//
//  vec3.swift
//  iTrace
//
//  Created by Fabrizio Pezzola on 05/01/2020.
//  Copyright © 2020 Fabrizio Pezzola. All rights reserved.
//

import simd

typealias Color = Vector3

infix operator •: BitwiseShiftPrecedence
infix operator ×: BitwiseShiftPrecedence

public struct Vector3 {
    // MARK: model
    public var model: simd_double3
    
    // MARK: properties
    public var x: Double { get { return model.x } set { model.x = newValue } }
    public var y: Double { get { return model.y } set { model.y = newValue } }
    public var z: Double { get { return model.z } set { model.z = newValue } }
    public var r: Double { get { return model.x } set { model.x = newValue } }
    public var g: Double { get { return model.y } set { model.y = newValue } }
    public var b: Double { get { return model.z } set { model.z = newValue } }
    public var squaredLength: Double { return simd_length_squared(self.model) }
    public var length: Double { return simd_length(self.model) }
    public var normalize: Vector3 { return self / length }
    
    static let Dummy: Vector3 = Vector3(0.0, 0.0, 0.0)
    
    // MARK: initialization
    public init(_ x: Double, _ y: Double, _ z: Double) {
        self.model = simd_double3(x: x, y: y, z: z)
    }
    
    public init(_ from: simd_double3) {
        self.model = from
    }

    // MARK: methods
    public mutating func makeUnitVector() {
        model *= (1.0 / length)
    }

    // MARK: custom operators
    // dot product
    public static func •(lhs: Vector3, rhs: Vector3) -> Double {
        return simd_dot(lhs.model, rhs.model)
    }
    
    public static func ×(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(simd_cross(lhs.model, rhs.model))
    }
    
    // MARK: operator overloads
    public static prefix func -(vec3: Vector3) -> Vector3 { return Vector3(-vec3.model) }
    
    public static func +(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(lhs.model + rhs.model)
    }
    
    public static func -(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(lhs.model - rhs.model)
    }
    
    public static func *(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(lhs.model * rhs.model)
    }
    
    public static func /(lhs: Vector3, rhs: Vector3) -> Vector3 {
        return Vector3(lhs.model / rhs.model)
    }
    
    public static func +(lhs: Vector3, rhs: Double) -> Vector3 {
        return Vector3(lhs.x + rhs, lhs.y + rhs, lhs.z + rhs)
    }
    
    public static func -(lhs: Vector3, rhs: Double) -> Vector3 {
        return Vector3(lhs.x - rhs, lhs.y - rhs, lhs.z - rhs)
    }
    
    public static func *(lhs: Vector3, rhs: Double) -> Vector3 {
        return Vector3(lhs.model * rhs)
    }
    
    public static func *(lhs: Double, rhs: Vector3) -> Vector3 {
        return Vector3(lhs * rhs.model)
    }
    
    public static func /(lhs: Vector3, rhs: Double) -> Vector3 {
        return Vector3(lhs.model / rhs)
    }
    
    public static func +=(lhs: inout Vector3, rhs: Vector3) {
        lhs.model += rhs.model
    }
    
    public static func -=(lhs: inout Vector3, rhs: Vector3) {
        lhs.model -= rhs.model
    }
    
    public static func *=(lhs: inout Vector3, rhs: Vector3) {
        lhs.model *= rhs.model
    }
    
    public static func /=(lhs: inout Vector3, rhs: Vector3) {
        lhs.model /= rhs.model
    }
    
    public static func +=(lhs: inout Vector3, rhs: Double) {
        lhs.x += rhs; lhs.y += rhs; lhs.z += rhs;
    }
    
    public static func -=(lhs: inout Vector3, rhs: Double) {
        lhs.x -= rhs; lhs.y -= rhs; lhs.z -= rhs;
    }
    
    public static func *=(lhs: inout Vector3, rhs: Double) {
        lhs.model *= rhs
    }
    
    public static func /=(lhs: inout Vector3, rhs: Double) {
        lhs.model /= rhs
    }
    
    public subscript(index: Int) -> Double {
        return self.model[index]
    }
}
