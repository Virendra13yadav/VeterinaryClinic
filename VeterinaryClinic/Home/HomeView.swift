//
//  ContentView.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.verticalSizeClass) private var vSizeClass
    @StateObject private var viewModel: HomeViewModel = HomeViewModel(service: NetworkService())
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showToast = false
    
    var body: some View {
        ZStack {
            if vSizeClass == .compact {
                CompactView
            } else {
                PortraitView
            }
            
            ShowDetailsToast
        }
        .padding()
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            viewModel.getSettings()
            viewModel.getAllPets()
        }
        
    }
    
    @ViewBuilder
    private var CompactView: some View {
        HStack(spacing: 16) {
            VStack(spacing: 20) {
                ChatCallView
                WorkingHoursView
            }
            .frame(maxWidth: 180, alignment: .center)
            
            Divider()
            
            PetsView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private var PortraitView: some View {
        VStack(spacing: 16) {
            ChatCallView
            WorkingHoursView
            Divider()
            PetsView
        }
    }
    
    @ViewBuilder
    private var ChatCallView: some View {
        if let settings = viewModel.settings {
            HStack(spacing: 16) {
                if settings.isChatEnabled {
                    Button("Chat") {
                        handleTap()
                    }
                    .tint(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                
                if settings.isCallEnabled {
                    Button("Call") {
                        handleTap()
                    }
                    .tint(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.green)
                    .cornerRadius(8)
                }
                
            }
            .alert("Message", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    @ViewBuilder
    private var WorkingHoursView: some View {
        if let hours = viewModel.settings?.workHours {
            Text(hours)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.gray.opacity(0.1))
                .border(Color.gray)
        }
    }
    
    @ViewBuilder
    private var PetsView: some View {
       if let pets = viewModel.pets {
           ScrollView(.vertical, showsIndicators: false) {
                ForEach(pets) { pet in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            
                            AsyncImage(url: pet.imageNSURL) { image in
                                image.petImageStyle()
                            } placeholder: {
                                Image.petPlaceholder
                                    .petImageStyle()
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(pet.title)
                                    .font(.headline)
                                
                                Text("Date: \(readableDate(from: pet.dateAdded))")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                //open webview
                                Button("Content Details") {
                                    if let url = URL(string: pet.contentURL) {
                                        router.pushWeb(url)
                                    } else {
                                        handleToast()
                                    }
                                }
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                            }
                        }
                        
                        Divider()
                    }

                }
            }
            
        } else {
            Text("No pets loaded yet")
                .foregroundColor(.gray)
        }
    }
    
    @ViewBuilder
    private var ShowDetailsToast: some View {
        if showToast {
            VStack {
                Spacer()
                ToastView(message: "Details are currently not available.")
                    .padding(.bottom, 40)
            }
            .animation(.easeInOut, value: showToast)
            .transition(.opacity)
        }
    }
    
    private func handleToast() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showToast = false
        }
    }
    
    private func handleTap() {
        if let hours = viewModel.settings?.workHours, isWithinWorkHours(hours) {
            alertMessage = ConstantsMSG.withinWorkHours
        } else {
            alertMessage = ConstantsMSG.outsideWorkHours
        }
        showAlert = true
    }
    
    private func readableDate(from isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short

        if let date = isoFormatter.date(from: isoString) {
            return displayFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }

}

#Preview {
    HomeView()
}
