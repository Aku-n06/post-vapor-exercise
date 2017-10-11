//
//  UsersController.swift
//  HelloPackageDescription
//
//  Created by Alberto Scampini on 11.10.17.
//

import Vapor
import HTTP
import AuthProvider

final class UsersController {

    // register a new User
    func signIn( _ req : Request) throws -> ResponseRepresentable {
        guard let username = req.data["username"]?.string
            , let password = req.data["password"]?.string
        else {
            throw Abort(.badRequest)
        }

        let user = MyUser(username: username, password: password)

        // ensure no user with this email already exists
        guard try MyUser.makeQuery().filter("email", user.username).first() == nil else {
            throw Abort(.badRequest, reason: "A user with that email already exists.")
        }

        try user.save()

        return "added \(username)"
    }

    // login the user returning a token
//    func logIn( _ req : Request) throws -> ResponseRepresentable {
//
//    }

}

