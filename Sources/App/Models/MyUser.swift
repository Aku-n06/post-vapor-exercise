//
//  MyUser.swift
//  HelloPackageDescription
//
//  Created by Alberto Scampini on 11.10.17.
//

import Vapor
import FluentProvider
import AuthProvider

final class MyUser: Model {
    let storage = Storage()

    let username: String
    let password: String

    /// Creates a new User
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    // MARK: Row

    /// Initializes the User from the
    /// database row
    init(row: Row) throws {
        username = try row.get("name")
        password = try row.get("password")
    }

    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("username", username)
        try row.set("password", password)
        return row
    }
}

extension MyUser: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Users
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("username")
            builder.string("password")
        }
    }

    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

import AuthProvider

extension MyUser: TokenAuthenticatable {
    // the token model that should be queried
    // to authenticate this user
    public typealias TokenType = MyToken
}
