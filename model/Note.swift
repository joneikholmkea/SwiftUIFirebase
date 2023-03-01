//
//  Note.swift
//  SwiftUIFirebase
//
//  Created by Jon Eikholm on 14/02/2023.
//

import Foundation
import UIKit

class Note:Identifiable {
    var id:String
    var text:String
    var image:UIImage? = nil
    var hasImage = false
    
    init(id: String, text: String, hasImage:Bool) {
        self.id = id
        self.text = text
        self.hasImage = hasImage
    }
    
}
