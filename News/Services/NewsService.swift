//  Created by Aji Prakosa on 19/5/25.

import Foundation
import RxSwift

class NewsService {
    func fetchTopHeadlines(category: String, page: Int = 1) -> Observable<NewsResponse> {
        let params: [String: Any] = [
            "category": category,
            "page": page,
            "pageSize": 20
        ]
        return APIManager.shared.request(endpoint: "top-headlines", parameters: params)
    }
    
    func fetchSources(category: String) -> Observable<SourceResponse> {
        let params: [String: Any] = [
            "category": category
        ]
        return APIManager.shared.request(endpoint: "sources", parameters: params)
    }
    
    func fetchArticles(from source: String, page: Int = 1) -> Observable<NewsResponse> {
        let params: [String: Any] = [
            "sources": source,
            "page": page,
            "pageSize": 20
        ]
        return APIManager.shared.request(endpoint: "everything", parameters: params)
    }
    
    func searchArticles(query: String, page: Int = 1) -> Observable<NewsResponse> {
        let params: [String: Any] = [
            "q": query,
            "page": page,
            "pageSize": 20
        ]
        return APIManager.shared.request(endpoint: "everything", parameters: params)
    }
}
