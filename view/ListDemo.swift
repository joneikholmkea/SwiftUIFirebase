//
//  ListDemo.swift
//  FirstIOSapp
//
//  Created by Jon Eikholm on 06/02/2023.
//

import SwiftUI

struct ListDemo: View {
    @ObservedObject var fileMan = fService
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Button {
                        fileMan.addNote(txt: "New note")
                    } label: {
                        Text("Add item")
                    }
                    Spacer()
                }.padding(10)
                List($fileMan.notes, editActions: .all){ note in
                    NavigationLink(destination: DetailViewDemo(message: note.text, note: note)){
                        Text(note.text.wrappedValue)
                    }
                }
            }
            
        }
    }
    
}

//struct Item : Identifiable, Codable {
//    var id = UUID()
//    var title:String
//    init(title: String) {
//        self.title = title
//    }
//}

struct ListDemo_Previews: PreviewProvider {
    static var previews: some View {
        ListDemo()
    }
}
