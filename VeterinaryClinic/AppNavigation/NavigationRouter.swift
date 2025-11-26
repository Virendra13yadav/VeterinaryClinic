//
//  NavigationRouter.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import SwiftUI

enum APIRouter {
    case settings(id: String)

    var url: URL? {
        switch self {
        case .settings(let id):
            return URL(string: APIBase.baseURL + id)
        }
    }
}

enum Route: Hashable {
    case webView(URL)
}

final class NavigationRouter: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
    
    //webview
    func pushWeb(_ url: URL) {
        push(.webView(url))
    }
}
