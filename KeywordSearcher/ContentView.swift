//
//  ContentView.swift
//  KeywordSearcher
//
//  Created by Adam on 7/30/21.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: KeywordSearcherDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(KeywordSearcherDocument()))
    }
}
