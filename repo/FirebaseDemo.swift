//
//  FirebaseDemo.swift
//  SwiftUIFirebase
//
//  Created by Jon Eikholm on 21/02/2023.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class FirebaseDemo:ObservableObject{
    private var db = Firestore.firestore() // holds the database object
    private var storage = Storage.storage()
    private let collection = "notes"
    @Published var notes = [Note]()
    
    func downloadImage(){
        let imageRef = storage.reference(withPath: "mountain.png")
        imageRef.getData(maxSize: 5000000) { data, error in
            if error == nil {
                let image = UIImage(data: data!)
                print(image?.description)
                // save image in Note object
            }else {
                print("error downloading \(error.debugDescription)")
            }
        }
    }
    
    func uploadImage(){
        if let img = UIImage(named: "mountain"){
            let data = img.pngData()! // forcefully unwrap
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            let ref = storage.reference().child("mountain.png")
            ref.putData(data, metadata: metaData){ meta, error in
                if error == nil {
                    print("OK uploading image")
                }else {
                    print("Not OK uploading image")
                }
            }
        }
    }
    
    
    func addItem(text:String){
        let doc = db.collection(collection).document() // creates a new empty document
        var data = [String:String]()  // empty map
        data["text"] = text
        doc.setData(data)
    }
    
    func startListener(){
        db.collection(collection).addSnapshotListener { snap, error in
            if error == nil {
                if let s = snap {
                    self.notes.removeAll()
                    for doc in s.documents {
                        if let str = doc.data()["text"] as? String{
                            print(str)
                            let n = Note(id: doc.documentID, text: str, hasImage: false) // change hasImage ...
                            self.notes.append(n)
                        }
                    }
                }
            }
            
            
        }
        
    }
}
