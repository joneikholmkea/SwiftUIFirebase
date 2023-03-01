//
//  FirebaseService.swift
//  SwiftUIFirebase
//
//  Created by Jon Eikholm on 14/02/2023.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit
var fService = FirebaseService() // global scope

class FirebaseService: ObservableObject{
    private var db = Firestore.firestore() // holds the database object
    let storage = Storage.storage() // for files
    private let notesColl = "notes"
    @Published var notes = [Note]() // empty array
    private let hasImage = "hasImage"
    private let text = "text"
    
    init(){
        startListener()
    }
    
    func addNote(txt:String){
        let doc = db.collection(notesColl).document() // creates a new empty document
        var data = [String:Any]() // creates a new empty dictionary
        data[text] = txt
        data[hasImage] = false
        doc.setData(data) // saves to Firestore.
    }
    
    func updateNote(note:Note){
        if note.image != nil {
            uploadImage(note: note)
        }
        if !note.hasImage{
            deleteImage(note: note)
        }
        let doc = db.collection(notesColl).document(note.id) // gets the document reference
        var data = [String:Any]() // creates a new empty dictionary
        data[text] = note.text
        data[hasImage] = note.hasImage
        doc.setData(data) // saves to Firestore.
    }
    
    func deleteImage(note:Note){
        let imageRef = storage.reference().child(note.id)
        imageRef.delete { error in
            if error == nil {
                print("deleted image \(note.id)")
            } else {
                print("failed to deleted image \(note.id) with error \(error.debugDescription)")
            }
        }
    }
    
    func uploadImage(note:Note){
        if let img = note.image{
                deleteImage(note: note) // delete first the old image.
                let data = img.jpegData(compressionQuality: 1.0)!
                let imageRef = storage.reference().child(note.id)
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                imageRef.putData(data, metadata: metaData) { meta, error in  // if file exist, no upload
                    if error == nil {
                        print("UPload OK")
                    }else {
                        print("upload not OK \(error)")
                    }
                }
            }
    }
    
    func downloadImage(note:Note, completion: @escaping (UIImage?) -> Void) {
        print("downloadImage()")
        let imageRef = storage.reference(withPath: note.id)
        imageRef.getData(maxSize: 7000000) { data, error in
               if error == nil {
                   print("Download OK")
                    completion(UIImage(data: data!))
               }else {
                   print("Download not OK")
               }
           }
       }
    
    
    func startListener(){
        db.collection(notesColl).addSnapshotListener { snap, error in
            if let e = error {
                print("some error loading data \(e)")
            }else {
                if let snap = snap {
                    self.notes.removeAll()
                    for doc in snap.documents{
                        if let txt = doc.data()[self.text] as? String
                            , let hasImage = doc.data()[self.hasImage] as? Bool{
                            print(txt)
                            let note = Note(id: doc.documentID, text: txt, hasImage: hasImage)
                            
                            self.notes.append(note)
                        }
                    }
                }
            }
        }
    }
    
    
}
