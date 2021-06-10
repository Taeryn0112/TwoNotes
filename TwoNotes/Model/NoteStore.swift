//
//  NoteStore.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/3/20.
//

import UIKit
import RealmSwift

/*
 This class handles all operations related to `Note` objects.
 This includes:
 - fetching all notes from the database
 - saving/creating notes to the database
 - updating notes to the database
 - deleting notes from the database
 */

public class NoteStore {
    private let realm = try! Realm()
    var allNote = [Note]()
    var noteMainVC: NotesMainViewController!
    var folderTitle: String!
    
    init() {
        self.fetchNotesFromDataBase()
        
    }
    
    // Load all the notes when the app starts
    func fetchNotesFromDataBase() {
        let notes = Array(realm.objects(Note.self).sorted(byKeyPath: "orderingValue", ascending: true))
        self.allNote = notes
        
    }
    
    private func save(_ note: Note) {
        try! realm.write {
            realm.add(note)
        }
    }

    func deleteNote(_ note: Note) {
        try! self.realm.write {
            self.realm.delete(note)
        }
        // remove the note from allNotes
        if let index = allNote.firstIndex(of: note) {
            allNote.remove(at: index)
            
        }
        // update ordering value
        updateOrderingValue()
    }
    
    func storeNote(_ note: Note) {
        save(note)
        allNote.insert(note, at: 0)
        updateOrderingValue()
    }
    
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let originalNote = allNote[fromIndex]

        allNote.remove(at: fromIndex)
        allNote.insert(originalNote, at: toIndex)
        
        updateOrderingValue()

    }
    
    private func updateOrderingValue() {
        // for all the items in the allNotes array
        // update the orderingValue to the index in the array
        try! realm.write {
        for note in allNote {
            if let index = allNote.firstIndex(of: note) {
                note.orderingValue = index
            }
        }
     }
  }
}
