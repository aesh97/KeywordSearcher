//
//  KeywordSearcherDocument.swift
//  KeywordSearcher
//
//  Created by Adam on 7/30/21.
//

import SwiftUI
import UniformTypeIdentifiers


extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "com.example.plain-text")
    }
}
extension NSMutableAttributedString {
    
    func FindAllIndexes(string:NSMutableAttributedString) -> [Int] {
        var counter = 0
        
        var INDEXES: Array<Int> = Array()
        for char in self.string {
            if (String(char) == string.string) {
                INDEXES.append(counter)
            }
            counter += 1
        }
        return(INDEXES)
    }
    
}




struct KeywordSearcherDocument: FileDocument {
    var text: NSMutableAttributedString
    func getHit(search:NSMutableAttributedString)->[NSMutableAttributedString] {
        let array: Array<NSMutableAttributedString> = self.getSentences()
        var HitSentences: Array<NSMutableAttributedString> = Array()
        for element in array {
            if (element.string.uppercased().contains(search.string.uppercased())) {
                HitSentences.append(element)
                
            }
        }
        
        
        
        return(HitSentences)
    }
    
    func getSentences() -> [NSMutableAttributedString] {
        var array: Array<NSMutableAttributedString> = Array()
        var test = [0]
        test.append(contentsOf: self.text.FindAllIndexes(string: NSMutableAttributedString(string:"!")))
        test.append(contentsOf: self.text.FindAllIndexes(string: NSMutableAttributedString(string:"?")))
        test.append(contentsOf: self.text.FindAllIndexes(string: NSMutableAttributedString(string:".")))
        test.sort()
       
        var interArr:Array<NSMutableAttributedString> = Array()
        
        for i in 1 ..< test.count {
            
            
            if (i == 1) {
                interArr.append(self.text.attributedSubstring(from: NSRange(location: test[i-1], length: test[i]-test[i-1]+1)) as! NSMutableAttributedString)
                
            } else {
                interArr.append(self.text.attributedSubstring(from: NSRange(location: test[i-1]+1, length: test[i]-test[i-1])) as! NSMutableAttributedString)
            }
            
            
            
            
        }
        
        
        
        for i in 0 ..< interArr.count {
            array.append(interArr[i])
        }
        
        
        
        
        return(array)
    }
    
    
    func getText()->(String) {
        return (self.text.string)
    }
    
    init(text: NSMutableAttributedString = NSMutableAttributedString(string:"")) {
        
        self.text = text
        
    }
    
    
    
    static var readableContentTypes: [UTType] { [.exampleText] }
    
    
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        
        
        else {
            print("yuck")
            print(configuration.contentType)
           
            throw CocoaError(.fileReadCorruptFile)
            
            
        }
        text = NSMutableAttributedString(string: string)

    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.string.data(using: .utf8)!
        
        return .init(regularFileWithContents: data)
    }
}
