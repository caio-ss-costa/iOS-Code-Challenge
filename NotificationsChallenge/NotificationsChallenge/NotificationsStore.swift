//
//  NotificationsStore.swift
//  NotificationsChallenge
//
//  Created by Caio Costa on 11/09/26.
//

import Foundation

struct NotificationsStore {
    let session: URLSession
    let baseURL = URL(string: "https://api.example.com")!

    static let mocked: NotificationsStore = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return NotificationsStore(session: URLSession(configuration: configuration))
    }()

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }

    func fetchNotifications() async throws -> [NotificationItem] {
        let url = baseURL.appendingPathComponent("notifications")
        let (data, _) = try await session.data(from: url)
        return try decoder.decode(NotificationsResponse.self, from: data).notifications
    }

    func fetchDetails(id: Int) async throws -> NotificationDetails {
        let url = baseURL.appendingPathComponent("notifications/\(id)")
        let (data, _) = try await session.data(from: url)
        return try decoder.decode(NotificationDetails.self, from: data)
    }
}
