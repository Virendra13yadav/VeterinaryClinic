//
//  ContentView.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel: HomeViewModel = HomeViewModel(service: NetworkService())
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showToast = false
    
    var body: some View {
        ZStack {
            VStack {
                ChatCallView
                WorkingHoursView
                PetsView
            }
            
            ShowDetailsToast
        }
        .onAppear {
            viewModel.getSettings()
            viewModel.getAllPets()
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
            .padding(.horizontal)
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
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var PetsView: some View {
        if let pets = viewModel.myPets {
            List {
                ForEach(pets) { pet in
                    HStack(alignment: .top, spacing: 12) {

                        //images loading
                        AsyncImage(url: pet.imageNSURL) { image in
                            image.petImageStyle()
                        } placeholder: {
                            Image.petPlaceholder
                                .petImageStyle()
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(pet.title)
                                .font(.headline)

                            Text("Added: \(pet.dateAdded)")
                                .font(.caption)
                                .foregroundColor(.gray)

                            //open webview
                            Button("Open Details") {
                                if let url = URL(string: pet.contentURL) {
                                    router.openWeb(url: url)
                                } else {
                                    handleToast()
                                }
                            }
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .listStyle(PlainListStyle())
            
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
                ToastView(message: "Detials URL not found!")
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
}

#Preview {
    HomeView()
}
