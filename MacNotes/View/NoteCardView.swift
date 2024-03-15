//
//  NoteCardView.swift
//  MacNotes
//
//  Created by Julia Gurbanova on 15.03.2024.
//

import SwiftUI

struct NoteCardView: View {
    @Bindable var note: Note
    var isKeyboardEnabled: FocusState<Bool>.Binding
    
    var body: some View {
        TextEditor(text: $note.content)
            .focused(isKeyboardEnabled)
            .overlay(alignment: .leading, content: {
                Text("Finish Work")
                    .foregroundStyle(.gray)
                    .padding(.leading, 5)
                    .opacity(note.content.isEmpty ? 1 : 0)
                    .allowsHitTesting(false)
            })
            .font(.body)
            .kerning(1.2)
            .scrollContentBackground(.hidden)
            .multilineTextAlignment(.leading)
            .padding(15)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.15), in: .rect(cornerRadius: 12))
    }
}

