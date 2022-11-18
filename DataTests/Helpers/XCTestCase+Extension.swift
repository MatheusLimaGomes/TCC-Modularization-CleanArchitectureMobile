//
//  XCTestCase+Extension.swift
//  DataTests
//
//  Created by Matheus F S L Gomes on 18/11/22.
//

import XCTest
public extension XCTestCase {
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
