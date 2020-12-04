//
//  NoteStore.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/3/20.
//

import UIKit

class NoteStore {
    
    var allNote = [Note]()
    
    @discardableResult func storeNote() -> Note {
        
        let newNote = Note(random: true)
        
        allNote.append(newNote)
        
        return newNote
        
        
    }
    
    init() {
        for _ in 0..<5 {
            storeNote()
        }
    }
    
    
    
}
