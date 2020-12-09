//
//  NoteStore.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/3/20.
//

import UIKit


class NoteStore {
    
    var allNote = [Note]()
   
    func storeNote(_ note: Note) {
        
        allNote.append(note)
        
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
