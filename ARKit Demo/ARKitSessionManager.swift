//
//  ARKitSessionManager.swift
//  ARKit Demo
//
//  Created by Amar Gandhi on 24/04/2024.
//

import SwiftUI
import ARKit

@MainActor
class ARKitSessionManager: ObservableObject {

    let session = ARKitSession()
    let worldTracking = WorldTrackingProvider()
    let handTracking = HandTrackingProvider()

    func startSession() async {
        if WorldTrackingProvider.isSupported {
            do {
                try await session.run([worldTracking, handTracking])
            } catch {
                assertionFailure("Failed to run session: \(error)")
            }
        }
    }

    func stopSession() {
        session.stop()
    }

    func handleWorldTrackingUpdates() async {
        print("\(#function): called")
        for await update in worldTracking.anchorUpdates {
            print("\(#function): anchorUpdates: \(update)")
        }
    }

    func monitorSessionEvent() async {
        print("\(#function): called")
        for await event in session.events {
            print("\(#function): \(event)")
        }
    }

    func reportDevicePose() {
        if let pose = worldTracking.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()) {
            print("pose: \(pose)")
        } else {
            print("pose: nil")
        }
    }

    func getOriginFromDeviceTransform() -> simd_float4x4 {
        guard let pose = worldTracking.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()) else {
            return simd_float4x4()
        }
        return pose.originFromAnchorTransform
    }
    
    
}
