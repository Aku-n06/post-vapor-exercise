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

    func getPosts(_ req: Request) throws -> ResponseRepresentable {
        guard let userName = req.data["userName"]?.string else {
            throw Abort(.badRequest)
        }

        guard let user = try? MyUser.makeQuery().filter("userName", userName).first()
            else {
                throw Abort(.unauthorized, reason: "user not found")
        }

        if user == nil {
            throw Abort(.notFound, reason: "user not found")
        }

        guard let posts = try? Post.makeQuery().filter("userId", user!.id).all()
            else {
                throw Abort(.unauthorized, reason: "error getting the posts")
        }

        guard posts.count != 0
            else {
                throw Abort(.unauthorized, reason: "no posts found")
        }

        var postList = Array<String>()
        for post in posts {
            postList.append(post .content)
        }

        return "\(postList)"
    }

}
