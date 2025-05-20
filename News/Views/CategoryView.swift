//  Created by Aji Prakosa on 19/5/25.

import SwiftUI
import RxSwift
import RxCocoa

struct CategoryView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var selectedCategory: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        NavigationLink(
                            destination: SourceView(category: category),
                            tag: category,
                            selection: $selectedCategory,
                            label: {
                                CategoryCard(category: category)
                            })
                    }
                }
                .padding()
            }
            .navigationTitle("News Categories")
        }
    }
}

struct CategoryCard: View {
    let category: String
    
    var body: some View {
        VStack {
            Image(systemName: iconForCategory(category))
                .font(.system(size: 40))
                .padding()
            
            Text(category.capitalized)
                .font(.headline)
        }
        .frame(width: 150, height: 150)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 1)
        )
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category {
        case "business": return "briefcase"
        case "entertainment": return "film"
        case "general": return "newspaper"
        case "health": return "heart"
        case "science": return "flask"
        case "sports": return "sportscourt"
        case "technology": return "desktopcomputer"
        default: return "questionmark"
        }
    }
}
