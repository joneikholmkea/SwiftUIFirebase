//
//  ContentView.swift
//  SwiftUIFirebase
//
//  Created by Jon Eikholm on 14/02/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var demoFirebase = FirebaseDemo()
    var firebaseExtra = FirebaseExtra()
    var body: some View {
        VStack {
            List($demoFirebase.notes){item in
                HStack{
                    Text(item.text.wrappedValue)
                    //Image(uiImage: item.image)
                }
            }
        }
        .onAppear(){
            //demoFirebase.downloadImage()
//            demoFirebase.startListener()
            firebaseExtra.downloadImage()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
