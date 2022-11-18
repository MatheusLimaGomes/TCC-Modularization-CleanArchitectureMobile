//
//  Data+Extension.swift
//  Data
//
//  Created by Matheus F S L Gomes on 18/11/22.
//

import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        try? JSONDecoder().decode(T.self, from: self)
    }
}
