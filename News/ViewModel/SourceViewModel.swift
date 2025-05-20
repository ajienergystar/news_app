//  Created by Aji Prakosa on 19/5/25.

import Foundation
import RxSwift
import RxCocoa
import Combine

class SourceViewModel: ObservableObject {
    private let newsService = NewsService()
    private let disposeBag = DisposeBag()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage = 1
    private var currentCategory = ""
    private var allSources: [Source] = []
    
    let searchQuery = PublishSubject<String>()
    let loadMore = PublishSubject<Void>()
    let refresh = PublishSubject<Void>()
    
    @Published var sources: [Source] = []
    @Published var isLoading = false
    @Published var isRefreshing = false
    @Published var error: IdentifiableError?
    
    init(category: String) {
        self.currentCategory = category
        setupBindings()
        fetchSources(refresh: true)
    }
    
    private func setupBindings() {
        searchQuery
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] query in
                self?.filterSources(query: query)
            })
            .disposed(by: disposeBag)
            
        loadMore
            .subscribe(onNext: { [weak self] _ in
                self?.fetchSources()
            })
            .disposed(by: disposeBag)
            
        refresh
            .subscribe(onNext: { [weak self] _ in
                self?.fetchSources(refresh: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchSources(refresh: Bool = false) {
        if refresh {
            currentPage = 1
            isRefreshing = true
        } else {
            isLoading = true
        }
        
        newsService.fetchSources(category: currentCategory)
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }
                    
                    if refresh {
                        self.allSources = response.sources
                    } else {
                        self.allSources.append(contentsOf: response.sources)
                    }
                    
                    self.sources = self.allSources
                    self.currentPage += 1
                    self.isLoading = false
                    self.isRefreshing = false
                },
                onError: { [weak self] error in
                    self?.error = IdentifiableError(error: error)
                    self?.isLoading = false
                    self?.isRefreshing = false
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func filterSources(query: String) {
        if query.isEmpty {
            sources = allSources
        } else {
            sources = allSources.filter { $0.name?.lowercased().contains(query.lowercased()) ?? false }
        }
    }
}

struct IdentifiableError: Identifiable {
    let id = UUID()
    let error: Error
    
    var localizedDescription: String {
        error.localizedDescription
    }
}
