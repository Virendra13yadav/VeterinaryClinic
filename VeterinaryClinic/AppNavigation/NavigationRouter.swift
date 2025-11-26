//
//  NavigationRouter.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import Foundation

enum APIRouter {
    case settings(id: String)

    var url: URL? {
        switch self {
        case .settings(let id):
            return URL(string: APIBase.baseURL + id)
        }
    }
}

final class AppRouter: ObservableObject {
    @Published var route: Route?

    enum Route: Identifiable {
        case webView(URL)

        var id: String {
            switch self {
            case .webView(let url): return "\(url.absoluteString)"
            }
        }
    }

    func openWeb(url: URL) {
        self.route = .webView(url)
    }
}
