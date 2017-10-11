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
        guard try MyUser.makeQuery().filter("username", user.username).first() == nil else {
            throw Abort(.badRequest, reason: "A user with that email already exists.")
        }

        try user.save()

        return "added \(username)"
    }

    // login the user returning a token
    func logIn( _ req : Request) throws -> ResponseRepresentable {
        guard let username = req.data["username"]?.string
            , let password = req.data["password"]?.string
            else {
                throw Abort(.badRequest)
        }

        guard let user = try? MyUser.makeQuery().filter("username", username).filter("password", password).first()
            else {
                throw Abort(.notFound, reason: "error getting the user")
        }

        if user == nil {
            throw Abort(.notFound, reason: "wrong username or password")
        }

        let token = try MyToken.generate(for: user!)
        try token.save()

        return token.token
    }

    func userWithToken(_ req : Request) throws -> MyUser {

        guard let string = req.headers["token"]?.string
            else {
                throw Abort(.unauthorized, reason: "wrong token")
        }

        guard let token = try? MyToken.makeQuery().filter("token", string).first()
            else {
                throw Abort(.unauthorized, reason: "token error")
        }

        guard token != nil, let userId = token?.userId
        else {
            throw Abort(.unauthorized, reason: "token error")
        }

        guard let user = try? MyUser.makeQuery().filter("id", userId).first()
        else {
            throw Abort(.unauthorized, reason: "user not found")
        }

        if user == nil {
            throw Abort(.notFound, reason: "user not found")
        }

        return user!
    }
}

