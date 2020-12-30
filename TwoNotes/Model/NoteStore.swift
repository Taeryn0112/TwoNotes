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

class NoteStore {
    private let realm = try! Realm()
    var allNote = [Note]()

    init() {
        self.fetchNotesFromDataBase()
    }
    
    func fetchNotesFromDataBase()  {
        let notes = Array(realm.objects(Note.self).sorted(byKeyPath: "serialNumber", ascending: false))
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
    }
    
    func storeNote(_ note: Note) {
        save(note)
        fetchNotesFromDataBase()
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
