//
//  ViewModel.swift
//  ARKit Demo
//
//  Created by Amar Gandhi on 24/04/2024.
//

import SwiftUI
import RealityKit
import Observation

@Observable
class ViewModel {

    var showImmersiveSpace = false

    private var contentEntity = Entity()
    // x is to right of you y above you and z
    private let placeOffset: SIMD3<Float> = .init(x: 0.0, y: 0.0, z: 0.0)

    func setupContentEntity() -> Entity {
        contentEntity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
        contentEntity.components.set(CollisionComponent(shapes: [ShapeResource.generateSphere(radius: 20)], isStatic: true))
        return contentEntity
    }

    func addAxis(matrix: simd_float4x4) {
        let entity = try! Entity.load(named: "axis.usdz")
        entity.scale *= 5
        
        // Extract the position from the index finger transform
        let indexFingerPosition = SIMD3<Float>(matrix.columns.3.x, matrix.columns.3.y, matrix.columns.3.z)
        
        // Create a new transform with the index finger position and identity rotation
        let modifiedTransform = simd_float4x4(
            SIMD4(1, 0, 0, 0),
            SIMD4(0, 1, 0, 0),
            SIMD4(0, 0, 1, 0),
            SIMD4(indexFingerPosition.x, indexFingerPosition.y, indexFingerPosition.z, 1)
        )
        
        entity.transform = Transform(matrix: modifiedTransform)
        contentEntity.addChild(entity)
    }
    
    
    
}
