//
//  ContentView.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
