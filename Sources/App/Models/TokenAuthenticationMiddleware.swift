//
//  TokenAuthenticationMiddleware.swift
//  HelloPackageDescription
//
//  Created by Alberto Scampini on 11.10.17.
//

import Vapor
import AuthProvider
import FluentProvider

let config = try Config()

config.preparations.append(MyUser.self)
config.preparations.append(MyToken.self)

let drop = try Droplet(config)

let tokenMiddleware = TokenAuthenticationMiddleware(MyUser.self)

/// use this route group for protected routes
let authed = drop.grouped(tokenMiddleware)
