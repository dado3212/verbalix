//
//  ContentView.swift
//  Verbalix
//
//  Created by Alex Beals on 8/20/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var words: [Word]
  @State private var showPopup = false

  var body: some View {
      NavigationSplitView {
          List {
              ForEach(words) { word in
                VStack {
                  Text(word.word)
                    .font(.title)
                  
                  Text(word.definition)
                    .font(.subheadline)
                }
              }
              .onDelete(perform: deleteItems)
          }
          .toolbar {
              ToolbarItem(placement: .navigationBarTrailing) {
                  EditButton()
              }
              ToolbarItem {
                Button(action: {
                  showPopup = true
                }) {
                  Label("Add Item", systemImage: "plus")
                }
              }
          }
      } detail: {
          Text("Select an item")
      }
      .sheet(isPresented: $showPopup) {
        AddWordPopup(showPopup: $showPopup, addWord: addItem)
       }
  }

  private func addItem(word: String, definition: String) {
      withAnimation {
        let newItem = Word(word: word, definition: definition, dateAdded: Date())
          modelContext.insert(newItem)
      }
  }

  private func deleteItems(offsets: IndexSet) {
      withAnimation {
          for index in offsets {
              modelContext.delete(words[index])
          }
      }
  }
  
  private func generateRandomLetters(length: Int = 5) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyz"
      return String((0..<length).map { _ in letters.randomElement()! })
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Word.self, inMemory: true)
}
