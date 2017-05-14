//
//  Comment.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Foundation
import Alamofire

struct CommentCell {
    var body: String?
    var createdAt: Date?
    var userName: String?

    func bodyString() -> String {
        guard let body = body else { return "" }
        return body
    }

    func createdDateString() -> String {
        guard let date = createdAt else { return "" }
        return date.toReadableString
    }

    func userNameString() -> String {
        guard let userName = userName else { return "" }
        return userName
    }
}

// MARK: Model

final class Comment: ResponseObjectSerializable, ResponseCollectionSerializable {

    var url: String?
    var id: Int?
    var pullRequestReviewId: Int?
    var diffHunk: String?
    var path: String?
    var position: Int?
    var originalPosition: Int?
    var commitId: Int?
    var user: User?
    var body: String?
    var createdAt: Date?
    var updatedAt: Date?
    var pullRequestUrl: String?

    required init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any]
        else {
            return nil
        }

        if let url = representation["url"] as? String {
            self.url = url
        }

        if let id = representation["id"] as? Int {
            self.id = id
        }

        
        if let pullRequestReviewId = representation["pull_request_review_id"] as? Int {
            self.pullRequestReviewId = pullRequestReviewId
        }

        if let diffHunk = representation["diff_hunk"] as? String {
            self.diffHunk = diffHunk
        }

        if let path = representation["path"] as? String {
            self.path = path
        }

        if let position = representation["position"] as? Int {
            self.position = position
        }

        if let originalPosition = representation["original_position"] as? Int {
            self.originalPosition = originalPosition
        }

        if let commitId = representation["commit_id"] as? Int {
            self.commitId = commitId
        }

        if let userRepresentation = representation["user"] as? [String: Any] {
            self.user = User(response: response, representation: userRepresentation)
        }

        if let body = representation["body"] as? String {
            self.body = body
        }

        if let createdAtString = representation["created_at"] as? String {
            if let createdAt = createdAtString.toDate {
                self.createdAt = createdAt
            }
        }

        if let updatedAtString = representation["updated_at"] as? String {
            if let updatedAt = updatedAtString.toDate {
                self.updatedAt = updatedAt
            }
        }

        if let pullRequestUrl = representation["pull_request_url"] as? String {
            self.pullRequestUrl = pullRequestUrl
        }
    }

    func commentCell() -> CommentCell {
        return CommentCell(body: body, createdAt: createdAt, userName: user?.login)
    }

    /**
     Fetches pull request's comments from GitHub
     - parameter paramters: Int pull request number
     - parameter completionHandler: Callback for proccessing the response
     
     - Note: currently hardcoded for only one owner and one repo see Router.swift
     */
    static func getComments(prNumber: Int, completionHandler: @escaping (_ response: DataResponse<[Comment]>) -> Void) {
        Alamofire.request(Router.getPRComments(prNumber))
            .responseCollection { (response: DataResponse<[Comment]>) in
                completionHandler(response)
            }
    }
}
