//
//  Commit.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/13/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Foundation
import Alamofire

struct CommitCell {
    var userName: String?
    var date: Date?
    var message: String?
    
    func messageString() -> String {
        guard let message = message else { return "" }
        return message
    }
    
    func dateString() -> String {
        guard let date = date else { return "" }
        return date.toReadableString
    }
    
    func userNameString() -> String {
        guard let userName = userName else { return "" }
        return userName
    }
}

// MARK: Model

final class Commit: ResponseObjectSerializable, ResponseCollectionSerializable {

    var name: String?
    var email: String?
    var date: Date?
    var message: String?

    required init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any]
        else {
            return nil
        }

        if let commit = representation["commit"] as? [String: Any] {
            if let committer = commit["committer"] as? [String: Any] {
                if let name = committer["name"] as? String {
                    self.name = name
                }

                if let email = committer["email"] as? String {
                    self.email = email
                }

                if let dateString = committer["date"] as? String {
                    if let date = dateString.toDate {
                        self.date = date
                    }
                }
            }

            if let message = commit["message"] as? String {
                self.message = message
            }
        }
    }

    func commitCell() -> CommitCell {
        return CommitCell(userName: name, date: date, message: message)
    }

    /**
     Fetches pull request's comments from GitHub
     - parameter paramters: Int pull request number
     - parameter completionHandler: Callback for proccessing the response
     
     - Note: currently hardcoded for only one owner and one repo see Router.swift
     */
    static func getCommits(prNumber: Int, completionHandler: @escaping (_ response: DataResponse<[Commit]>) -> Void) {
        Alamofire.request(Router.getPRCommits(prNumber))
            .responseCollection { (response: DataResponse<[Commit]>) in
                completionHandler(response)
        }
    }
}
