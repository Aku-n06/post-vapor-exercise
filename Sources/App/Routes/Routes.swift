import Vapor
import FluentProvider
import AuthProvider

extension Droplet {
    
    func setupRoutes() throws {

        let uc = UsersController()
        let mc = MessageController()

        // MARK: - Authentications

        get("me") { req in
            // return the authenticated user's name
            let user = try uc.userWithToken(req)

            return "username : \(user.username)"
        }

        // MARK: - PeopleController handlers

        post("signIn", handler: uc.signIn)

        post("logIn", handler: uc.logIn)

        post("addPost", handler: mc.addPost)

    }
    
}
