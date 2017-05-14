//
//  PullRequest.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/12/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Foundation
import Alamofire

struct PRCell {
    var title: String?
    var number: Int?
    var openDate: String?
    var userName: String?
    
    func numberString() -> String {
        guard let number = number else { return "" }
        return "#\(number)"
    }
    
    func openDescription() -> String {
        switch (openDate, userName) {
        case let (.some(openDate), .some(userName)):
            return "opened on \(openDate) by \(userName)"
        case let (.some(openDate), .none):
            return "opened on \(openDate)"
        case let (.none, .some(userName)):
            return "opened by \(userName)"
        default:
            return ""
        }
    }
}

// MARK: Model

final class PullRequest: ResponseObjectSerializable, ResponseCollectionSerializable {
    enum State: String {
        case open
        case close
        case all
    }

    var id: Int?
    var url: String?
    var htmlUrl: String?
    var diffUrl: String?
    var patchUrl: String?
    var issueUrl: String?
    var commitsUrl: String?
    var reviewCommentsUrl: String?
    var reviewCommentUrl: String?
    var commentsUrl: String?
    var statusesUrl: String?
    var number: Int?
    var state: String?
    var title: String?
    var body: String?
    var assignee: User?
    var milestone: [String: Any]?
    var locked: Bool?
    var createdAt: Date?
    var updatedAt: Date?
    var closedAt: Date?
    var mergedAt: Date?
    var head: [String: Any]?
    var user: User?

    required init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any]
        else {
            return nil
        }

        if let id = representation["id"] as? Int {
            self.id = id
        }

        if let url = representation["url"] as? String {
            self.url = url
        }

        if let htmlUrl = representation["html_url"] as? String {
            self.htmlUrl = htmlUrl
        }

        if let diffUrl = representation["diff_url"] as? String {
            self.diffUrl = diffUrl
        }

        if let patchUrl = representation["patch_url"] as? String {
            self.patchUrl = patchUrl
        }

        if let issueUrl = representation["issue_url"] as? String {
            self.issueUrl = issueUrl
        }

        if let commitsUrl = representation["commits_url"] as? String {
            self.commitsUrl = commitsUrl
        }

        if let reviewCommentsUrl = representation["review_comments_url"] as? String {
            self.reviewCommentsUrl = reviewCommentsUrl
        }
        if let reviewCommentUrl = representation["review_comment_url"] as? String {
            self.reviewCommentUrl = reviewCommentUrl
        }

        if let commentsUrl = representation["comments_url"] as? String {
            self.commentsUrl = commentsUrl
        }

        if let statusesUrl = representation["statuses_url"] as? String {
            self.statusesUrl = statusesUrl
        }

        if let number = representation["number"] as? Int {
            self.number = number
        }

        if let state = representation["state"] as? String {
            self.state = state
        }

        if let title = representation["title"] as? String {
            self.title = title
        }

        if let body = representation["body"] as? String {
            self.body = body
        }

        if let assigneeRepresentation = representation["assignee"] as? [String: Any] {
            self.assignee = User(response: response, representation: assigneeRepresentation)
        }

        if let locked = representation["locked"] as? Bool {
            self.locked = locked
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

        if let closedAtString = representation["closed_at"] as? String {
            if let closedAt = closedAtString.toDate {
                self.closedAt = closedAt
            }
        }

        if let mergedAtString = representation["merged_at"] as? String {
            if let mergedAt = mergedAtString.toDate {
                self.mergedAt = mergedAt
            }
        }

        if let userRepresentation = representation["user"] as? [String: Any] {
            self.user = User(response: response, representation: userRepresentation)
        }
    }

    func prCell() -> PRCell {
        return PRCell(title: title,
                      number: number,
                      openDate: updatedAt?.toReadableString,
                      userName: user?.login)
    }

    /**
        Fetches PullRequest from GitHub
        - parameter paramters: [String: Any]  filtering parameters
        - parameter completionHandler: Callback for proccessing the response
        
        - Note: currently hardcoded for only one owner and one repo see Router.swift
    */
    static func getPullRequests(parameters: [String: Any], completionHandler: @escaping (_ response: DataResponse<[PullRequest]>) -> Void) {
        Alamofire.request(Router.getPullRequests(parameters))
            .responseCollection { (response: DataResponse<[PullRequest]>) in
                completionHandler(response)
            }
    }
}
