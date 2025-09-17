//
//  MoviePlayerTests.swift
//  MoviePlayerTests
//
//  Created by Madeleine Sekar Putri Wijayanto on 04/10/24.
//

import XCTest
@testable import MoviePlayer

final class MoviePlayerTests: XCTestCase {
    func testFetchMoviesSuccess() {
            let jsonResponse = """
            {
                "categories": [
                    {
                        "title": "Action",
                        "movies": [
                            {
                                "title": "Mad Max: Fury Road",
                                "short_description": "A post-apocalyptic action film.",
                                "image_url": "https://example.com/madmax.jpg",
                                "long_synopsis": "In a desolate world..."
                            }
                        ]
                    }
                ]
            }
            """

            let data = jsonResponse.data(using: .utf8)!
            let url = URL(string: "https://bootcamp-api-json-ten.vercel.app/api/json")!
            
            URLProtocolMock.testURLs = [url: data]
            let config = URLSessionConfiguration.ephemeral
            config.protocolClasses = [URLProtocolMock.self]
        _ = URLSession(configuration: config)

            let expectation = self.expectation(description: "Movies fetched successfully")
            
            NetworkManager.shared.fetchMovies { categories in
                XCTAssertNotNil(categories)
                XCTAssertEqual(categories?.first?.title, "Action")
                XCTAssertEqual(categories?.first?.movies.first?.title, "Mad Max: Fury Road")
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10, handler: nil)
        }
    
    func testFilterSelection() {
            let mockDelegate = MockFilterDelegate()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let filterVC = storyboard.instantiateViewController(identifier: "FilterViewController") as! FilterViewController
            filterVC.delegate = mockDelegate
            filterVC.loadViewIfNeeded()
            
            let indexPath = IndexPath(row: 0, section: 0)
            filterVC.tableView(filterVC.tableView, didSelectRowAt: indexPath)

            XCTAssertEqual(mockDelegate.selectedFilter, MovieFilter.allCases[0])
        }
}

class URLProtocolMock: URLProtocol {
    static var testURLs = [URL?: Data]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url, let data = URLProtocolMock.testURLs[url] {
            self.client?.urlProtocol(self, didLoad: data)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

class MockFilterDelegate: FilterViewControllerDelegate {
        var selectedFilter: MovieFilter?
        
        func didSelectFilter(filter: MovieFilter) {
            selectedFilter = filter
        }
    }
