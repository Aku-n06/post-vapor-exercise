import Vapor
import FluentProvider
import AuthProvider

extension Droplet {
    
    func setupRoutes() throws {

        let pc = PeopleController()
        let uc = UsersController()

        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in return req.description }

        try resource("posts", PostController.self)

        // MARK: - Authentications

        get("me") { req in
            // return the authenticated user's name
            return try req.user().username
        }

        // MARK: - PeopleController handlers

        get("show", handler: pc.showPeople)

        post("add", handler: pc.addPerson)

        post("signIn", handler: uc.signIn)
        

    }
}
