//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Matheus F S L Gomes on 16/11/22.
//

import XCTest

class RemoteAddAccount {
    private var url: URL
    private var httpClient: HttpClient
    init(url: URL, httpClient: HttpClient) {
        self.url = url
        self.httpClient = httpClient
    }
    func add() {
        httpClient.post(url: url)
    }
}
protocol HttpClient {
    func post(url: URL)
}
final class RemoteAddAccountTests: XCTestCase {
    
    func test_() throws {
        let url = URL(string: "http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        sut.add()
        XCTAssertEqual(httpClientSpy.url, url)
    }

    class HttpClientSpy: HttpClient {
        var url: URL?

        func post(url: URL) {
            self.url = url
        }
    }

}
