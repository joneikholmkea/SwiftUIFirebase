//
//  DetailViewDemo.swift
//  FirstIOSapp
//
//  Created by Jon Eikholm on 06/02/2023.
//

import SwiftUI
import PhotosUI

struct DetailViewDemo: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var picture: UIImage? // main GUI thread, works fine
    @Binding var message:String
    @Binding var note:Note
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Button("Save") {
                        print("saving")
                        note.text = message
                        fService.updateNote(note: note)
                    }
                    Button("Delete image") {
                        note.image = nil
                        note.hasImage = false
                        picture = nil
                    }
                }
                TextField("", text: $message, axis: .vertical)
                
                VStack{
                    Image(uiImage: picture ?? UIImage(systemName: "photo.circle.fill")!)
                        .resizable()
                        .frame(width: 250, height: 250)
                }
                
            }
        }.toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("Select a photo")
                }
            }
        }
        .onChange(of: selectedItem) { item in
            Task(priority: .background) {
                print("image ready")
                if let data = try? await item?.loadTransferable(type: Data.self){
                    note.image = UIImage(data: data)
                    picture = note.image
                    note.hasImage = true
                }
            }
        }.onAppear(){
            print("onAppear ")
            if note.hasImage {
                fService.downloadImage(note: note){ imageFromFB in
                    picture = imageFromFB
                }
            }
        }
    }
}

struct DetailViewDemo_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewDemo(message: .constant("hej"), note: .constant(Note(id: "1", text: "text", hasImage: false)))
    }
}
