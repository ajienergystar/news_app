//
//  Article.swift
//  News
//
//  Created by mac on 19/5/25.
//

import Foundation

struct Article: Codable, Identifiable {
    let id = UUID()  // Untuk memenuhi Identifiable
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    // CodingKeys untuk menyesuaikan dengan respons API
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }
}

struct Source: Codable {
    let id: String?
    let name: String?
}

// Extension untuk format tanggal
extension Article {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: publishedAt) else {
            return publishedAt
        }
        
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    var cleanURL: URL? {
        URL(string: url)
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToImage else { return nil }
        return URL(string: urlToImage)
    }
}
