//
//  ARKit_DemoApp.swift
//  ARKit Demo
//
//  Created by Amar Gandhi on 24/04/2024.
//

import SwiftUI

@main
struct ARKit_DemoApp: App {

    @State private var model = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environment(model)
        }
    }
}
