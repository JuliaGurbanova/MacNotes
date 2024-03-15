//
//  NotesView.swift
//  MacNotes
//
//  Created by Julia Gurbanova on 15.03.2024.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    var category: String?
    var allCategories: [NoteCategory]
    @Query private var notes: [Note]
    @Environment(\.modelContext) private var context
    @FocusState private var isKeyboardEnabled: Bool

    init(category: String?, allCategories: [NoteCategory]) {
        self.category = category
        self.allCategories = allCategories
        let predicate = #Predicate<Note> {
            return $0.category?.categoryTitle == category
        }

        let favoritePredicate = #Predicate<Note> {
            return $0.isFavorite
        }

        let finalPredicate = category == "All Notes" ? nil : (category == "Favorites" ? favoritePredicate : predicate)

        _notes = Query(filter: finalPredicate, sort: [], animation: .snappy)
    }

    var body: some View {
        GeometryReader {
            let size = $0.size
            let width = size.width

            let rowCount = max(Int(width / 250), 1)

            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: rowCount), spacing:  10) {
                    ForEach(notes) { note in
                        NoteCardView(note: note, isKeyboardEnabled: $isKeyboardEnabled)
                            .contextMenu {
                                Button(note.isFavorite ? "Remove from Favorites" : "Add to Favorites") {
                                    note.isFavorite.toggle()
                                }

                                Menu {
                                    ForEach(allCategories) { category in
                                        Button {
                                            note.category = category
                                        } label: {
                                            HStack(spacing: 5) {
                                                if category == note.category {
                                                    Image(systemName: "checkmark")
                                                        .font(.caption)
                                                }

                                                Text(category.categoryTitle)
                                            }
                                        }
                                    }

                                    Button("Remove from Categories") {
                                        note.category = nil
                                    }
                                } label: {
                                    Text("Category")
                                }

                                Button("Delete", role: .destructive) {
                                    context.delete(note)
                                }
                            }
                    }
                }
                .padding(12)
            }
            .onTapGesture {
                isKeyboardEnabled = false
            }
        }
    }
}

#Preview {
    ContentView()
}
