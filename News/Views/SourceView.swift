//  Created by Aji Prakosa on 19/5/25.

import SwiftUI
import RxSwift
import RxCocoa

struct SourceView: View {
    let category: String
    @StateObject private var viewModel: SourceViewModel
    @State private var searchText = ""
    
    init(category: String) {
        self.category = category
        _viewModel = StateObject(wrappedValue: SourceViewModel(category: category))
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding()
                .onChange(of: searchText) { newValue in
                    viewModel.searchQuery.onNext(newValue)
                }
            
            if viewModel.isRefreshing {
                ProgressView()
            } else {
                List {
                    ForEach(viewModel.sources, id: \.id) { source in
                        NavigationLink(
                            destination: ArticleView(source: source.id ?? ""),
                            label: {
                                SourceRow(source: source)
                            })
                    }
                    
                    if !viewModel.sources.isEmpty && !viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .onAppear {
                                viewModel.loadMore.onNext(())
                            }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle(category.capitalized)
        .alert(item: $viewModel.error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct SourceRow: View {
    let source: Source
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(source.name ?? "Unknown Source")
                .font(.headline)
            
            if let description = source.id {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
