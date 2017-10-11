//
//  Request+Authentication.swift
//  HelloPackageDescription
//
//  Created by Alberto Scampini on 11.10.17.
//

import Vapor
import AuthProvider
import FluentProvider

extension Request {
    func user() throws -> MyUser {
        return try auth.assertAuthenticated()
    }
}
