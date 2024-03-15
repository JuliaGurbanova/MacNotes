//
//  NoteCategory.swift
//  MacNotes
//
//  Created by Julia Gurbanova on 15.03.2024.
//

import Foundation
import SwiftData

@Model
class NoteCategory {
    var categoryTitle: String
    
    @Relationship(deleteRule: .cascade, inverse: \Note.category)
    var notes: [Note]?

    init(categoryTitle: String) {
        self.categoryTitle = categoryTitle
    }
}
