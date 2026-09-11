//
//  MockURlProtocol.swift
//  NotificationsChallenge
//
//  Created by Caio Costa on 11/09/26.
//


import Foundation

final class MockURLProtocol: URLProtocol {

    // MARK: - Sample JSON

    static let notificationsJSON = """
    {
        "notifications": [
            {
                "id": 1,
                "title": "Lab results ready",
                "body": "Critical lab results for patient John Doe (Room 302) are ready for review",
                "type": "clinical",
                "priority": 1,
                "isRead": false,
                "createdAt": "2026-09-11T10:15:00Z"
            },
            {
                "id": 2,
                "title": "Medication order updated",
                "body": "Dr. Smith updated the medication order for patient Jane Roe (Room 214)",
                "type": "clinical",
                "priority": 0,
                "isRead": true,
                "createdAt": "2026-09-10T18:42:00Z"
            },
            {
                "id": 3,
                "title": "Scheduled system maintenance",
                "body": "The EHR system will be unavailable tonight from 02:00 to 04:00",
                "type": "broadcast",
                "priority": 0,
                "isRead": false,
                "createdAt": "2026-09-09T08:00:00Z"
            }
        ]
    }
    """

    static let notificationDetailsJSONByID: [Int: String] = [
        1: """
        {
            "id": 1,
            "title": "Lab results ready",
            "body": "Critical lab results for patient John Doe (Room 302) are ready for review",
            "type": "clinical",
            "priority": 1,
            "isRead": false,
            "createdAt": "2026-09-11T10:15:00Z",
            "sender": {
                "id": 42,
                "name": "Central Laboratory",
                "avatarURL": "https://example.com/avatars/lab.png"
            },
            "actions": [
                { "label": "View results", "deeplink": "app://patients/302/labs" },
                { "label": "Acknowledge", "deeplink": "app://notifications/1/ack" }
            ]
        }
        """,
        2: """
        {
            "id": 2,
            "title": "Medication order updated",
            "body": "Dr. Smith updated the medication order for patient Jane Roe (Room 214)",
            "type": "clinical",
            "priority": 0,
            "isRead": true,
            "createdAt": "2026-09-10T18:42:00Z",
            "sender": {
                "id": 77,
                "name": "Dr. Emily Smith",
                "avatarURL": "https://example.com/avatars/smith.png"
            },
            "actions": [
                { "label": "Review order", "deeplink": "app://patients/214/medications" },
                { "label": "Contact prescriber", "deeplink": "app://staff/77/message" }
            ]
        }
        """,
        3: """
        {
            "id": 3,
            "title": "Scheduled system maintenance",
            "body": "The EHR system will be unavailable tonight from 02:00 to 04:00",
            "type": "broadcast",
            "priority": 0,
            "isRead": false,
            "createdAt": "2026-09-09T08:00:00Z",
            "sender": {
                "id": 1,
                "name": "Hospital IT Department",
                "avatarURL": "https://example.com/avatars/it.png"
            },
            "actions": [
                { "label": "View maintenance schedule", "deeplink": "app://announcements/maintenance" }
            ]
        }
        """
    ]

    // MARK: - Routing

    private static func defaultResponses() -> [String: (statusCode: Int, data: Data)] {
        var responses: [String: (statusCode: Int, data: Data)] = [
            "/notifications": (200, Data(notificationsJSON.utf8))
        ]
        for (id, json) in notificationDetailsJSONByID {
            responses["/notifications/\(id)"] = (200, Data(json.utf8))
        }
        return responses
    }

    /// Map of URL path -> (statusCode, JSON data)
    static var mockResponses: [String: (statusCode: Int, data: Data)] = defaultResponses()

    /// Optional error to simulate network failures
    static var mockError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        guard
            let url = request.url,
            let mock = MockURLProtocol.mockResponses[url.path]
        else {
            client?.urlProtocol(self, didFailWithError: URLError(.unsupportedURL))
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: mock.statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )!

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: mock.data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        // Nothing to cancel — responses are returned synchronously.
    }

    /// Call in tearDown to restore the default responses
    static func reset() {
        mockResponses = defaultResponses()
        mockError = nil
    }
}
