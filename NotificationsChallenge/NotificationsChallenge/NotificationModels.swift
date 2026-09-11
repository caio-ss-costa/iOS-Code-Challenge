//
//  NotificationModels.swift
//  NotificationsChallenge
//
//  Created by Caio Costa on 11/09/26.
//

import Foundation

struct NotificationsResponse: Decodable {
    let notifications: [NotificationItem]
}

struct NotificationItem: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let body: String
    let type: String
    let isRead: Bool
    let createdAt: Date
}

struct NotificationDetails: Decodable {
    let id: Int
    let title: String
    let body: String
    let type: String
    let isRead: Bool
    let createdAt: Date
    let sender: Sender?
    let actions: [Action]

    struct Sender: Decodable, Hashable {
        let id: Int
        let name: String
        let avatarURL: URL
    }

    struct Action: Decodable, Hashable {
        let label: String
        let deeplink: String
    }
}
