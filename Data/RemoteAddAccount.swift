//
//  RemoteAddAccount.swift
//  Data
//
//  Created by Matheus F S L Gomes on 16/11/22.
//

import Foundation
import Domain

public final class RemoteAddAccount {
    private var url: URL
    private var httpClient: HttpPostClient
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    func add(addAccountModel: AddAccountModel, completion: @escaping (DomainError) -> Void) {
        httpClient.post(to: url, with: addAccountModel.toData()) { error in
            completion(.unexpected)
        }
    }
}
