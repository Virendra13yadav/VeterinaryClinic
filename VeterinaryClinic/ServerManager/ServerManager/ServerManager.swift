//
//  ServerManager.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import Foundation
import Combine

enum APIError: LocalizedError {
    case invalidURL
    case serverError(Int)
    case decodingError
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .serverError(let code):
            return "Server returned error \(code)."
        case .decodingError:
            return "Failed to decode server response."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

protocol NetworkServicing {
    func request<T: Decodable>(_ route: APIRouter) -> AnyPublisher<T, APIError>
}

final class NetworkService: NetworkServicing {

    func request<T: Decodable>(_ route: APIRouter)
    -> AnyPublisher<T, APIError> {

        guard let url = route.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")

        return URLSession.shared.dataTaskPublisher(for: request)
            // Log raw response before decoding
            .handleEvents(receiveOutput: { output in
                if let pretty = self.prettyPrintedJSON(output.data) {
                    print("📩 Response JSON:\n\(pretty)")
                } else {
                    print("📩 Response Raw Data:\n\(String(decoding: output.data, as: UTF8.self))")
                }
            })
            .tryMap(validateResponse)
            .tryMap { data in
                try self.decodeJSON(data, to: T.self)
            }
            .mapError(self.mapToAPIError)
            .eraseToAnyPublisher()
    }

    // MARK: - Helpers
    private func validateResponse(_ result: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = result.response as? HTTPURLResponse else {
            throw APIError.unknown(URLError(.badServerResponse))
        }

        guard (200...299).contains(response.statusCode) else {
            throw APIError.serverError(response.statusCode)
        }
        return result.data
    }

    private func decodeJSON<T: Decodable>(_ data: Data, to type: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw APIError.decodingError
        }
    }

    private func mapToAPIError(_ error: Error) -> APIError {
        if let apiError = error as? APIError { return apiError }
        if error is DecodingError { return .decodingError }
        return .unknown(error)
    }
    
    private func prettyPrintedJSON(_ data: Data) -> String? {
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
            return String(decoding: prettyData, as: UTF8.self)
        } catch {
            return nil
        }
    }
}
