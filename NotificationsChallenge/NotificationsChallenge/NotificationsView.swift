//
//  NotificationsView.swift
//  NotificationsChallenge
//
//  Created by Caio Costa on 11/09/26.
//

import SwiftUI

struct NotificationsView: View {
    let store: NotificationsStore

    @State private var notifications: [NotificationItem] = []

    var body: some View {
        NavigationStack {
            List(notifications) { notification in
                NotificationRow(notification: notification)
            }
            .listStyle(.plain)
            .navigationTitle("Notifications")
        }
        .onAppear {
            Task {
                notifications = try await store.fetchNotifications()
            }
        }
    }
}

private struct NotificationRow: View {
    let notification: NotificationItem

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.headline)
                Text(notification.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(notification.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            if !notification.isRead {
                Circle()
                    .fill(.blue)
                    .frame(width: 10, height: 10)
                    .padding(.top, 6)
            }
        }
        .padding(.vertical, 4)
    }

    private var icon: String {
        switch notification.type {
        case "clinical": "cross.case.fill"
        case "broadcast": "megaphone.fill"
        default: "bell.fill"
        }
    }
}

#Preview {
    NotificationsView(store: .mocked)
}
