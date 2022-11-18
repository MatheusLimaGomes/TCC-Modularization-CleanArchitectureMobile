//
//  HttpPostClient.swift
//  Data
//
//  Created by Matheus F S L Gomes on 16/11/22.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?, completion: @escaping (HttpError) -> Void)
}
 
