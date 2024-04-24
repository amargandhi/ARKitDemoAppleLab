//
//  ImmersiveView.swift
//  ARKit Demo
//
//  Created by Amar Gandhi on 24/04/2024.
//

import SwiftUI
import RealityKit
import ARKit

struct ImmersiveView: View {

    @Environment(ViewModel.self) private var model

    @ObservedObject var arkitSessionManager = ARKitSessionManager()
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    @State private var leftHandAnchor: HandAnchor?
        
        var body: some View {
            RealityView { content in
                content.add(model.setupContentEntity())
            }
            .task {
                await arkitSessionManager.startSession()
            }
            .task {
                await arkitSessionManager.handleWorldTrackingUpdates()
            }
            .task {
                await arkitSessionManager.monitorSessionEvent()
            }
            .onReceive(timer) { _ in
                arkitSessionManager.reportDevicePose()
            }
            .task {
                for await anchor in arkitSessionManager.handTracking.anchorUpdates {
                    if anchor.anchor.chirality == .left {
                        leftHandAnchor = anchor.anchor
                    }
                }
            }
            .gesture(
                SpatialTapGesture(count: 2)
                    .targetedToAnyEntity()
                    .onEnded { _ in
                        if let handAnchor = leftHandAnchor,
                           let wrist = handAnchor.handSkeleton?.joint(.wrist),
                           wrist.isTracked {
                            let originFromWrist = handAnchor.originFromAnchorTransform
                            let wristFromIndex = wrist.anchorFromJointTransform
                            let originFromIndex = matrix_multiply(originFromWrist, wristFromIndex)
                            
                            model.addAxis(matrix: originFromIndex)
                        }
                    }
            )
    }
}

//#Preview {
//    ImmersiveView()
//        .environment(ViewModel())
//        .previewLayout(.sizeThatFits)
//}
