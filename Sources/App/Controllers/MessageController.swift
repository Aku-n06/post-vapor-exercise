//
//  MessageController.swift
//  HelloPackageDescription
//
//  Created by Alberto Scampini on 11.10.17.
//

final class MessageController {

    let uc = UsersController()

    func addPost(_ req: Request) throws -> ResponseRepresentable {
        guard let message = req.data["message"]?.string else {
            throw Abort(.badRequest)
        }

        let user = try uc.userWithToken(req)

        let post = Post(content: message, userId: user.id!)
        try post.save()

        return "added \(message)"
    }

    //func getPosts(

}
