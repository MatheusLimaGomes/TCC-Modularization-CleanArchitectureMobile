//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Matheus F S L Gomes on 16/11/22.
//

import XCTest
import Domain
@testable import Data

final class RemoteAddAccountTests: XCTestCase {
    
    func test_add_should_call_http_client_with_correct_url() throws {
        let url = makeURL()
        let (sut, httpClientSpy) = makeSut(to: url)
        sut.add(addAccountModel: makeAddAccountModel()) { _ in }
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    func test_add_should_call_http_client_with_correct_data() throws {
        let (sut, httpClientSpy) = makeSut()
        let addAccountModelMock = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModelMock) { _ in }
        XCTAssertEqual(httpClientSpy.data, addAccountModelMock.toData())
    }
    func test_should_complete_with_error_when_complete_with_error() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut: sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivity)
        })
    }
    func test_should_complete_with_account_when_client_complete_with_valid_data() {
        let (sut, httpClientSpy) = makeSut()
        let account = makeAccountModel()
        expect(sut: sut, completeWith: .success(account)) {
            httpClientSpy.completeWithData(account.toData()!)
        }
    }
    func test_should_complete_with_error_if_client_complete_with_invalid_data() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut: sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithData(makeInvalidData())
        })
    }
    func test_should_not_complete_if_sut_has_been_dealocated() {
        let httpClient = HttpClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(
            url: makeURL(),
            httpClient: httpClient
        )
        var result: Result<AccountModel,DomainError>?
        sut?.add(
            addAccountModel: makeAddAccountModel()) { result = $0}
        sut = nil
        httpClient.completeWithError(.noConnectivity)
        XCTAssertNil(result)
    }
}

extension RemoteAddAccountTests {
    class HttpClientSpy: HttpPostClient {
        var urls: [URL] = [URL]()
        var data: Data?
        var completion: ((Result <Data, HttpError>) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping  (Result <Data, HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }
        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
        func completeWithData(_ data: Data) {
            completion?(.success(data))
        }
    }
    func makeAddAccountModel() -> AddAccountModel {
        AddAccountModel(name: "any name", email: "e-mail@maildomain.com", password: "secret", passwordConfirmation: "secret")
    }
    func makeAccountModel() -> AccountModel {
        AccountModel(
            id: "any_id",
            name: "any name",
            email: "mail@mail.com",
            password: "secret")
    }
    func makeInvalidData() -> Data {
        Data("invalid_data".utf8)
    }
    func makeURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    func makeSut(to url: URL = URL(string: "http://any-url.com")!, httpClient: HttpClientSpy = HttpClientSpy(), file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClient = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClient)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClient, file: file, line: line)
        return (sut: sut, httpClientSpy: httpClient)
    }
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
    func expect(sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wating")
        sut.add(
            addAccountModel: makeAddAccountModel()) { receivedResult in
                switch (expectedResult, receivedResult) {
                case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
                case (.success(let expectedResult), .success(let receivedResult)): XCTAssertEqual(expectedResult, receivedResult, file: file, line: line)
                default: XCTFail("Expected \(expectedResult) received \(receivedResult) instead!", file: file, line: line)
                }
                exp.fulfill()
            }
        action()
        self.wait(for: [exp], timeout: 1)
    }
}
