//
//  MacNotesApp.swift
//  MacNotes
//
//  Created by Julia Gurbanova on 15.03.2024.
//

import SwiftUI
import SwiftData

@main
struct MacNotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 320, minHeight: 400)
        }
        .windowResizability(.contentSize)
        .modelContainer(for: [Note.self, NoteCategory.self])
    }
}
