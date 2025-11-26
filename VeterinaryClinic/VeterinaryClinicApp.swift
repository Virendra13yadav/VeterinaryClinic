//
//  VeterinaryClinicApp.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import SwiftUI

@main
struct VeterinaryClinicApp: App {
    @StateObject private var router = NavigationRouter()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                HomeView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .webView(let url):
                            WebView(url: url)
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}
