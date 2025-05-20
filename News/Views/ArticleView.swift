//  Created by Aji Prakosa on 19/5/25.

import SwiftUI

struct ArticleView: View {
    let source: String
    @StateObject private var viewModel: ArticleViewModel
    @State private var searchText = ""
    
    init(source: String) {
        self.source = source
        _viewModel = StateObject(wrappedValue: ArticleViewModel(source: source))
    }
    
    var body: some View {
        VStack {
            if viewModel.isRefreshing {
                LoadingView()
            } else {
                articleList
            }
        }
        .navigationTitle("Articles")
        .toolbar {
            ToolbarItem(placement: .principal) {
                SearchBar(text: $searchText)
                    .frame(width: 200)
                    .onChange(of: searchText) { newValue in
                        viewModel.searchArticles(query: newValue)
                    }
            }
        }
        // Di View:
        .alert("Error", isPresented: Binding<Bool>(
            get: { viewModel.error != nil },
            set: { _ in viewModel.error = nil }
        )) {
            Button("OK") { viewModel.error = nil }
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Unknown error")
        }
    }
    
    private var articleList: some View {
        Group {
            if viewModel.articles.isEmpty {
                emptyStateView
            } else {
                List {
                    ForEach(viewModel.articles) { article in
                        NavigationLink(destination: WebView(url: URL(string: article.url)!)) {
                            NewsCard(article: article)
                                .padding(.vertical, 8)
                        }
                    }
                    
                    if !viewModel.isLoading {
                        loadingFooter
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("No articles found")
                .foregroundColor(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var loadingFooter: some View {
        ProgressView()
            .frame(maxWidth: .infinity, alignment: .center)
            .onAppear {
                viewModel.fetchArticles()
            }
    }
}
