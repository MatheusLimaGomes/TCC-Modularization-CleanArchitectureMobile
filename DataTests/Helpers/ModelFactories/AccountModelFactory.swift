//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by Matheus F S L Gomes on 18/11/22.
//

import Foundation
import Domain

func makeAccountModel() -> AccountModel {
    AccountModel(
        id: "any_id",
        name: "any name",
        email: "mail@mail.com",
        password: "secret")
}
