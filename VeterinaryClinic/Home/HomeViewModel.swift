//
//  HomeViewModel.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import Foundation
import SwiftUI
import Combine

extension HomeView {
    
    class HomeViewModel: ObservableObject {
        
        @Published var settings: Settings?
        @Published var myPets: [Pet]?
        @Published var errorMessage: String?

        private let service: NetworkServicing
        private var cancellables = Set<AnyCancellable>()

        init(service: NetworkServicing) {
            self.service = service
        }

        func getSettings() {
            service.request(APIRouter.settings(id: APIConstants.settingId))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                } receiveValue: { (response: SettingsResponse) in
                    self.settings = response.settings
                }
                .store(in: &cancellables)
        }
        
        func getAllPets() {
            service.request(APIRouter.settings(id: APIConstants.petsId))
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                } receiveValue: { (response: AllPets) in
                    self.myPets = response.pets
                }
                .store(in: &cancellables)
        }
    }
}
