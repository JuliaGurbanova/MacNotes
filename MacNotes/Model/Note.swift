//
//  Note.swift
//  MacNotes
//
//  Created by Julia Gurbanova on 15.03.2024.
//

import Foundation
import SwiftData

@Model
class Note {
    var content: String
    var isFavorite: Bool = false
    var category: NoteCategory?

    init(content: String, category: NoteCategory? = nil) {
        self.content = content
        self.category = category
    }
}
