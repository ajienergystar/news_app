//
//  NewsApp.swift
//  News
//
//  Created by mac on 19/5/25.
//

import SwiftUI

@main
struct NewsApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            CategoryView()
        }
    }
}
