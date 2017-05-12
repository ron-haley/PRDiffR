//
//  User.swift
//  PRDiffr
//
//  Created by Ronald Haley on 5/12/17.
//  Copyright © 2017 Ronald Haley. All rights reserved.
//

import Foundation

final class User: ResponseObjectSerializable, ResponseCollectionSerializable {

    var login: String?
    var id: Int?
    var avatarUrl: String?
    var gravatarId: Int?
    var url: String?
    var htmlUrl: String?
    var followersUrl: String?
    var followingUrl: String?
    var gistsUrl: String?
    var starredUrl: String?
    var subscriptionsUrl: String?
    var organizationsUrl: String?
    var reposUrl: String?
    var eventsUrl: String?
    var receivedEventsUrl: String?
    var type: String?
    var siteAdmin: Bool?
    var name: String?
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var hireable: Bool?
    var bio: String?
    var publicRepos: Int?
    var publicGists: Int?
    var followers: Int?
    var following: Int?
    var createdAt: Date?
    var updatedAt: Date?
    
    required init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any]
        else {
            return nil
        }

        if let login = representation["login"] as? String {
            self.login = login
        }

        if let id = representation["id"] as? Int {
            self.id = id
        }

        if let avatarUrl = representation["avatar_url"] as? String {
            self.avatarUrl = avatarUrl
        }

        if let gravatarId = representation["gravatar_id"] as? Int {
            self.gravatarId = gravatarId
        }

        if let url = representation["url"] as? String {
            self.url = url
        }

        if let htmlUrl = representation["html_url"] as? String {
            self.htmlUrl = htmlUrl
        }

        if let followersUrl = representation["followers_url"] as? String {
            self.followersUrl = followersUrl
        }

        if let followingUrl = representation["following_url"] as? String {
            self.followingUrl = followingUrl
        }

        if let gistsUrl = representation["gists_url"] as? String {
            self.gistsUrl = gistsUrl
        }

        if let starredUrl = representation["starred_url"] as? String {
            self.starredUrl = starredUrl
        }

        if let subscriptionsUrl = representation["subscriptions_url"] as? String {
            self.subscriptionsUrl = subscriptionsUrl
        }

        if let organizationsUrl = representation["organizations_url"] as? String {
            self.organizationsUrl = organizationsUrl
        }

        if let reposUrl = representation["repos_url"] as? String {
            self.reposUrl = reposUrl
        }

        if let eventsUrl = representation["events_url"] as? String {
            self.eventsUrl = eventsUrl
        }

        if let receivedEventsUrl = representation["received_events_url"] as? String {
            self.receivedEventsUrl = receivedEventsUrl
        }

        if let type = representation["type"] as? String {
            self.type = type
        }

        if let siteAdmin = representation["site_admin"] as? Bool {
            self.siteAdmin = siteAdmin
        }

        if let name = representation["name"] as? String {
            self.name = name
        }

        if let company = representation["company"] as? String {
            self.company = company
        }

        if let blog = representation["blog"] as? String {
            self.blog = blog
        }

        if let location = representation["location"] as? String {
            self.location = location
        }

        if let email = representation["email"] as? String {
            self.email = email
        }

        if let hireable = representation["hireable"] as? Bool {
            self.hireable = hireable
        }

        if let bio = representation["bio"] as? String {
            self.bio = bio
        }

        if let publicRepos = representation["public_repos"] as? Int {
            self.publicRepos = publicRepos
        }

        if let publicGists = representation["public_gists"] as? Int {
            self.publicGists = publicGists
        }

        if let followers = representation["followers"] as? Int {
            self.followers = followers
        }

        if let following = representation["following"] as? Int {
            self.following = following
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
    }
}
