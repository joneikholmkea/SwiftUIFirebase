//
//  FirebaseExtra.swift
//  SwiftUIFirebase
//
//  Created by Jon Eikholm on 22/02/2023.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit
class FirebaseExtra{
    
    private var db = Firestore.firestore()
    private let notesColl = "notes"
    private var storage = Storage.storage()
    
    
    func downloadImage(){
        let ref = storage.reference(withPath: "Ducati.png")
        ref.getData(maxSize: 5000000) { data, error in
            if error == nil {
                print("image download OK")
                let image = UIImage(data: data!) // can be used in SwiftUI
                print(image.debugDescription)
            }
        }
    }
    
    func uploadImage(){
        if let image = UIImage(named:"Ducati"){
            let data = image.pngData()!
            let ref = storage.reference().child("Ducati.png")
            let meta = StorageMetadata()
            meta.contentType = "image/png"
            ref.putData(data, metadata: meta){ meta, error in
                if error == nil {
                    print("success uploading image")
                }else {
                    print("failed to upload image")
                }
            }
        }
    }
    
    
    
    func addNote(str:String){
        let doc = db.collection(notesColl).document()
        var data = [String:String]()
        data["text"] = str
        doc.setData(data)
    }
    
    func startListener(){
        db.collection(notesColl).addSnapshotListener { snap, error in
            if let e = error {
                print("some error loading data \(e)")
            }else {
                if let snap = snap {
                    //self.notes.removeAll()
                    for doc in snap.documents{
                        if let txt = doc.data()["text"] as? String{
                            print(txt)
                           // let note = Note(id: doc.documentID, text: txt)
                            //self.notes.append(note)
                        }
                    }
                }
            }
        }
    }
    
    
}
