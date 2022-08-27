//
//  KeywordSearcherApp.swift
//  KeywordSearcher
//
//  Created by Adam on 7/30/21.
//

import SwiftUI


@main
struct KeywordSearcherApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: KeywordSearcherDocument()) { file in
            ContentView(document: file.$document)
        }       
    }
}


