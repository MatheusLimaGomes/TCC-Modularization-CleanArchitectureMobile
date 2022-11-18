//
//  DataTestFactories.swift
//  Data
//
//  Created by Matheus F S L Gomes on 18/11/22.
//

import Foundation

public func makeInvalidData() -> Data {
    Data("invalid_data".utf8)
}
public func makeURL() -> URL {
    URL(string: "http://any-url.com")!
}
