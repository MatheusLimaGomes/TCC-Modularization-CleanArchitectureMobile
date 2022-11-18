//
//  HttpClientSpy.swift
//  DataTests
//
//  Created by Matheus F S L Gomes on 18/11/22.
//

import Foundation
import Data

public final class HttpClientSpy: HttpPostClient {
    var urls: [URL] = [URL]()
    var data: Data?
    var completion: ((Result <Data, HttpError>) -> Void)?
    
    public func post(to url: URL, with data: Data?, completion: @escaping  (Result <Data, HttpError>) -> Void) {
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
