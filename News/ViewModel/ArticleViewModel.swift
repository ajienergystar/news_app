//  Created by Aji Prakosa on 19/5/25.

import Foundation
import RxSwift
import RxCocoa
import Combine

class ArticleViewModel: ObservableObject {
    private let newsService = NewsService()
    private let disposeBag = DisposeBag()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    private var currentSource = ""
    private var allArticles: [Article] = []
    private var searchQuery = ""
    
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var isRefreshing = false
    @Published var error: Error?
    
    init(source: String) {
        self.currentSource = source
        setupBindings()
        fetchArticles(refresh: true)
    }
    
    private func setupBindings() {
        // For RxSwift, we can still use as before
        // But for properties that need to be observable by SwiftUI, use @Published
    }
    
    func fetchArticles(refresh: Bool = false) {
        if refresh {
            currentPage = 1
            isRefreshing = true
        } else {
            isLoading = true
        }
        
        let request: Observable<NewsResponse>
        
        if searchQuery.isEmpty {
            request = newsService.fetchArticles(from: currentSource, page: currentPage)
        } else {
            request = newsService.searchArticles(query: searchQuery, page: currentPage)
        }
        
        let future = request.asFuture()
        
        future
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                self?.isRefreshing = false
                
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                if refresh {
                    self.allArticles = response.articles
                    self.articles = response.articles
                } else {
                    self.allArticles.append(contentsOf: response.articles)
                    self.articles = self.allArticles
                }
                
                self.currentPage += 1
            }
            .store(in: &cancellables)
    }
    
    func searchArticles(query: String) {
        searchQuery = query
        fetchArticles(refresh: true)
    }
}

extension Observable {
    func asFuture() -> Future<Element, Error> {
        return Future { promise in
            let disposable = self.subscribe(
                onNext: { element in
                    promise(.success(element))
                },
                onError: { error in
                    promise(.failure(error))
                }
            )
            
            // Menyimpan disposable agar tidak langsung di dispose
            _ = disposable.disposed(by: DisposeBag())
        }
    }
}
