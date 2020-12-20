//
//  NoteStore.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/3/20.
//

import UIKit
import RealmSwift

class NoteStore {
    
    var allNote = [Note]()
    
    func storeNote(_ note: Note) {
        
//        allNote.append(note)
        let notes = SceneDelegate.realm
        
        try! notes.write {
            //fetch the recent note
            let fetchNote = notes.objects(Note.self)
            
            
        }
    }
    
//    func fetchNotesFromDataBase() -> Results<Note> {
//        
//        let notes = realm?.objects(Note.self)
//        return notes!
//    }
    
    
    func removeNote(_ note: Note) {
        if let index = allNote.firstIndex(of: note) {
            allNote.remove(at: index)
            let notes = SceneDelegate.realm
            
            try! notes.write {
                
                
            }
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
