//
//  VeterinaryClinicApp.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import SwiftUI

@main
struct VeterinaryClinicApp: App {
    @StateObject private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(router)
        }
    }
}
