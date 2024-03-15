//
//  HomeView.swift
//  MacNotes
//
//  Created by Julia Gurbanova on 15.03.2024.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @Query(animation: .snappy) private var categories: [NoteCategory]
    @State private var selectedTag: String? = "All Notes"
    @State private var addCategory = false
    @State private var categoryTitle = ""
    @State private var requestedCategory: NoteCategory?
    @State private var deleteRequest = false
    @State private var renameRequest = false
    @State private var isDark = true

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTag) {
                Text("All Notes")
                    .tag("All Notes")
                    .foregroundStyle(selectedTag == "All Notes" ? Color.primary : .gray)
                Text("Favorites")
                    .tag("Favorites")
                    .foregroundStyle(selectedTag == "Favorites" ? Color.primary : .gray)

                Section {
                    ForEach(categories) { category in
                        Text(category.categoryTitle)
                            .tag(category.categoryTitle)
                            .foregroundStyle(selectedTag == category.categoryTitle ? Color.primary : .gray)
                            .contextMenu {
                                Button("Rename") {
                                    categoryTitle = category.categoryTitle
                                    requestedCategory = category
                                    renameRequest = true
                                }

                                Button("Delete") {
                                    categoryTitle = category.categoryTitle
                                    requestedCategory = category
                                    deleteRequest = true
                                }
                            }
                    }
                } header: {
                    HStack(spacing: 5) {
                        Text("Categories")

                        Button("", systemImage: "plus") {
                            addCategory.toggle()
                        }
                        .tint(.gray)
                        .buttonStyle(.plain)
                    }
                }
            }
        } detail: {
            NotesView(category: selectedTag, allCategories: categories)
        }
        .navigationTitle(selectedTag ?? "Notes")
        .alert("Add Category", isPresented: $addCategory) {
            TextField("Work", text: $categoryTitle)

            Button("Cancel", role: .cancel) {
                categoryTitle = ""
            }

            Button("Add") {
                let category = NoteCategory(categoryTitle: categoryTitle)
                context.insert(category)
                categoryTitle = ""
            }
        }
        .alert("Rename Category", isPresented: $renameRequest) {
            TextField("Work", text: $categoryTitle)

            Button("Cancel", role: .cancel) {
                categoryTitle = ""
                requestedCategory = nil
            }

            Button("Rename") {
                if let requestedCategory {
                    requestedCategory.categoryTitle = categoryTitle
                    categoryTitle = ""
                    self.requestedCategory = nil
                }
            }
        }
        .alert("Are you sure you want to delete \(categoryTitle) category?", isPresented: $deleteRequest) {
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
                requestedCategory = nil
            }

            Button("Delete", role: .destructive) {
                if let requestedCategory {
                    context.delete(requestedCategory)
                    categoryTitle = ""
                    self.requestedCategory = nil
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 10) {
                    Button("", systemImage: "plus") {
                        let note = Note(content: "")
                        context.insert(note)
                    }

                    Button("", systemImage: isDark ? "sun.min" : "moon") {
                        isDark.toggle()
                    }
                    .contentTransition(.symbolEffect(.replace))
                }
            }
        }
        .preferredColorScheme(isDark ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
