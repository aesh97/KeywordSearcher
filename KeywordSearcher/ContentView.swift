//
//  ContentView.swift
//  KeywordSearcher
//
//  Created by Adam on 7/30/21.
//

import SwiftUI



struct TextView: UIViewRepresentable {
    
    @Binding public var text: NSMutableAttributedString
    
    
    
    class Coordinator: NSObject, UITextViewDelegate {
        var control: TextView
        
        
     
        init(_ control: TextView) {
            
            self.control = control
            
            
            
        }
     
        func textViewDidChange(_ textView: UITextView) {
          
            control.text = NSMutableAttributedString(attributedString: textView.attributedText)
           
        }
        
        
    }

    
    func makeCoordinator() -> TextView.Coordinator {
        Coordinator(self)
    }
 
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.sizeToFit()
        view.adjustsFontForContentSizeCategory = true
        view.isUserInteractionEnabled = true
        view.allowsEditingTextAttributes = true
        view.attributedText = self.text
        view.textAlignment = .left
        view.adjustsFontForContentSizeCategory = true
        
        view.delegate = context.coordinator
        
        return view
    }
    
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        self.text.addAttribute(NSMutableAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20.0), range: NSRange(location: 0,length: self.text.string.count))
        
        uiView.attributedText = self.text
        uiView.textAlignment = .left
     
    }
    
    
}

struct ContentView: View {
    @Binding public var document: KeywordSearcherDocument
    @State public var startSearch = ""
    @State public var Hits: Array<NSMutableAttributedString> = Array()
    
    @State public var String: String = ""
    
    @State var scaleNow: CGFloat = 1
    
    @State var showBar = true
       
    var body: some View {
        
        let views = TextView(text: self.$document.text)
        
        VStack {
            
            if showBar {
                HStack {
                    TextField(
                            "Search",
                        text: $startSearch,
                        onCommit: {
                            Hits = document.getHit(search: NSMutableAttributedString(string: startSearch))
                            startSearch = ""
                            var index:Int = 0
                            
                            for sentence in document.getSentences() {
                                
                                
                                if (Hits.contains(sentence)) {
                                    document.text.addAttribute(NSMutableAttributedString.Key.foregroundColor, value: UIColor(Color.red), range: NSRange(location: index,length: sentence.string.count))
                                    index = index + sentence.string.count
                                    
                                    
                                } else {
                                    document.text.addAttribute(NSMutableAttributedString.Key.foregroundColor, value: UIColor(Color.black), range: NSRange(location: index,length: sentence.string.count))
                                    index = index + sentence.string.count
                                    
                                }
                            }
                            
                            index = 0
                                            
                            views.text = document.text
                            String = document.getText()
                        }
                    )
                    .border(Color(UIColor.separator))
                    .onAppear{
                        String = document.getText()
                    }
                    .background(Color.white)
                }
            }
            
            views
                .frame(minWidth: UIScreen.main.bounds.size.width/4.0, maxWidth: 0.9*UIScreen.main.bounds.size.width)
                .border(Color.black)
                .padding()
                
                .multilineTextAlignment(.center)
                .scaledToFill()
                .scaleEffect(scaleNow)
                .gesture(
                    MagnificationGesture()
                        .onChanged {scale in scaleNow = scale; showBar = false}
                        .onEnded{_ in scaleNow = scaleNow;
                            
                            if (scaleNow == 1) {
                                showBar = true
                                
                            }
                        }
                    
                    
                )
            
                .onTapGesture {
                    
                    scaleNow = 1
                    showBar = true
                }
        }
        .background(Color.gray)
    }
}




