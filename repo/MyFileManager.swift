//
//  FileManager.swift
//  SUIfirst
//
//  Created by Jon Eikholm on 07/02/2023.
//

import Foundation
class MyFileManager: ObservableObject{
    
    let userDefaults = UserDefaults.standard
    //let fService = FirebaseService()
    var myArray: [String] = ["A", "B"]
    
    @Published var items = [Note]()
    let arrayKey = "items"
    
    init() {
        //saveToFile()
        fService.startListener()
//        readFromUserDefaults()
    }
    
    func addItem(text:String) {
//        items.append(Item(title: text))
//        saveToUserDefaults()
        fService.addNote(txt: text)
    }
    
//    func saveToUserDefaults(){
//        do {
//            let encodedData = try JSONEncoder().encode(items)
//            userDefaults.set(encodedData, forKey: arrayKey)
//            print("saved to userdefaults \(items)")
//        } catch {
//        }
//    }
//
//    func readFromUserDefaults(){
//        if let savedData = userDefaults.object(forKey: arrayKey) as? Data {
//            do{
//                // 2
//                let results = try JSONDecoder().decode([Item].self, from: savedData)
//                self.items = results
//
//                for i in items{
//                    print(i)
//                }
//                print("size: \(items.count)")
//            } catch {
//            }
//        }
//    }
}

