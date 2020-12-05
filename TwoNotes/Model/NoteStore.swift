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
    
    func removeNote(_ note: Note) {
        if let index = allNote.firstIndex(of: note) {
            allNote.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let originalNote = allNote[fromIndex]
        
        allNote.remove(at: fromIndex)
        
        allNote.insert(originalNote, at: toIndex)
        
        
        
    }
    
    
    
}
