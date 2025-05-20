//  Created by Aji Prakosa on 19/5/25.

import Foundation
import RxSwift

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func request<T: Codable>(endpoint: String, parameters: [String: Any]? = nil) -> Observable<T> {
        return Observable.create { observer in
            var components = URLComponents(string: Constants.baseURL + endpoint)!
            
            var queryItems = [URLQueryItem(name: "apiKey", value: Constants.apiKey)]
            if let params = parameters {
                queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: "\($0.value)") })
            }
            
            components.queryItems = queryItems
            
            guard let url = components.url else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    observer.onError(APIError.invalidResponse)
                    return
                }
                
                guard let data = data else {
                    observer.onError(APIError.noData)
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decodedData)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case unknown
}
