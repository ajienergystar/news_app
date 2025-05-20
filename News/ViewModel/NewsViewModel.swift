//  Created by Aji Prakosa on 19/5/25.

import Foundation
import RxSwift
import RxCocoa
import Combine

class NewsViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    
    @Published var categories: [String] = Constants.categories
    @Published var isLoading = false
    @Published var error: IdentifiableError?
    
    let categorySelected = PublishSubject<String>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        categorySelected
            .subscribe(onNext: { [weak self] category in
            })
            .disposed(by: disposeBag)
    }
    
    func refreshCategories() {
        isLoading = true
        isLoading = false
    }
}
