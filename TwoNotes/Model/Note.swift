//
//  Note.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit

public class Note {
    
    var userInput: String
    var image: UIImage?
    
    init(note userInput: String, photo image: UIImage?) {
        self.userInput = userInput
        self.image = image
    }
    
}
