//
//  Model.swift
//  Domain
//
//  Created by Matheus F S L Gomes on 16/11/22.
//

import Foundation

public protocol Model: Codable {}
extension Model {
    public func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
