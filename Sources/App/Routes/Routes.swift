import Vapor
import FluentProvider
import AuthProvider

extension Droplet {
    
    func setupRoutes() throws {

        let pc = PeopleController()
        let uc = UsersController()

        let tokenMiddleware = TokenAuthenticationMiddleware(MyUser.self)
        /// use this route group for protected routes
        let authed = self.grouped(tokenMiddleware)

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
            let user = try uc.userWithToken(req)

            return "username : \(user.username)"
        }

        // MARK: - PeopleController handlers

        get("show", handler: pc.showPeople)

        post("add", handler: pc.addPerson)

        post("signIn", handler: uc.signIn)

        post("logIn", handler: uc.logIn)

    }
    
}
