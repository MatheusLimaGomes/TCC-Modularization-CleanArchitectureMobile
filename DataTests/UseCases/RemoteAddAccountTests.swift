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
        let url = URL(string: "http://any-url.com")!
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
        let exp = expectation(description: "wating client complete with fails")
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
                case .failure(let error): XCTAssertEqual(error, .unexpected)
                case .success: XCTFail("Expected an error received \(result) instead!")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
    func test_should_complete_with_account_when_client_complete_with_valid_data() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "wating client complete with success")
        let expectedAccount = makeAccountModel()
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case .failure: XCTFail("Expected success received \(result) instead!")
                case let .success(receivedAccount): XCTAssertEqual(receivedAccount, expectedAccount)
            }
            exp.fulfill()
        }
        httpClientSpy
            .completeWithData(expectedAccount.toData()!)
        wait(for: [exp], timeout: 1)
    }
    func test_should_complete_with_error_if_client_complete_with_invalid_data() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "wating client complete with error")
        let expectedAccount = makeAccountModel()
        sut.add(addAccountModel: makeAddAccountModel()) { result in
            switch result {
            case let .failure(error): XCTAssertEqual(error, .unexpected)
                case .success: XCTFail("Expected success received \(result) instead!")
            }
            exp.fulfill()
        }
        httpClientSpy
            .completeWithData(Data("invalid: data".utf8))
        wait(for: [exp], timeout: 1)
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
    func makeSut(to url: URL = URL(string: "http://any-url.com")!, httpClient: HttpClientSpy = HttpClientSpy()) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        (sut: RemoteAddAccount(url: url, httpClient: httpClient), httpClientSpy: httpClient)
    }
}
