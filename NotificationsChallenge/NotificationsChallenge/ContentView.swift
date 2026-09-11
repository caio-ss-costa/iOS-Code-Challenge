//
//  ContentView.swift
//  NotificationsChallenge
//
//  Created by Caio Costa on 11/09/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NotificationsView(store: .mocked)
    }
}

#Preview {
    ContentView()
}
