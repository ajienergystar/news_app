//
//  NewsServiceTests.swift
//  NewsTests
//
//  Created by mac on 19/5/25.
//

import XCTest
import RxSwift
@testable import News

class NewsServiceTests: XCTestCase {
    var newsService: NewsService!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        newsService = NewsService()
        disposeBag = DisposeBag()
    }
    
    func testFetchTopHeadlines() {
        let expectation = XCTestExpectation(description: "Fetch top headlines")
        
        newsService.fetchTopHeadlines(category: "technology")
            .subscribe(onNext: { response in
                XCTAssertEqual(response.status, "ok")
                XCTAssertFalse(response.articles.isEmpty)
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Request failed with error: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testFetchSources() {
        let expectation = XCTestExpectation(description: "Fetch sources")
        
        newsService.fetchSources(category: "technology")
            .subscribe(onNext: { response in
                XCTAssertEqual(response.status, "ok")
                XCTAssertFalse(response.sources.isEmpty)
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Request failed with error: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testSearchArticles() {
        let expectation = XCTestExpectation(description: "Search articles")
        
        newsService.searchArticles(query: "apple")
            .subscribe(onNext: { response in
                XCTAssertEqual(response.status, "ok")
                XCTAssertFalse(response.articles.isEmpty)
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Request failed with error: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 10)
    }
}
