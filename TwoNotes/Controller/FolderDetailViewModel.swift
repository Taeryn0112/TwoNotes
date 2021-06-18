//
//  FolderDetailViewModel.swift
//  TwoNotes
//
//  Created by Terry Lee on 6/10/21.
//

import Foundation
import RealmSwift

class FolderDetailViewModel {
    
    var folderObject: Folder!
    var realm = SceneDelegate.realm
    var noteDetailVC: NoteDetailViewController!
    var noteArray = [Note]()
    var note: Note!
    var notesMainVC: NotesMainViewController!
    
    init(folder: Folder) {
        self.folderObject = folder
        
    }
    
    var folderTitleText: String {
        return folderObject.folderTitle ?? ""
    }
    
    func viewDidLoad() {
        let sortedArray = realm.objects(Note.self).filter("folderSerialNumber = %@", folderObject.serialNumber)
        
        let sortByOrderArray = sortedArray.sorted(byKeyPath: "orderingValue", ascending: true)
//        self.noteArray.append(contentsOf: sortByOrderArray)
        self.noteArray.insert(contentsOf: sortByOrderArray, at: 0)
        
    }
    
//        func fetchNoteByFolderSerialFromDataBase() -> Results<Note> {
//
//            let note = realm.objects(Note.self).filter("self.note.folderSerialNumber == folderObject.serialNumber")
//            return note
//        }
//
//
//        func getNoteObjectByFolderSerial(for folderSerial: ObjectId) -> Note {
//
//            if folderObject.notes.count != 0 {
//            let allNotesBySerial = fetchNoteByFolderSerialFromDataBase()
//
//            for note in allNotesBySerial {
//                if note.folderSerialNumber == folderSerial {
//                    noteArray.append(note)
//                    }
//                }
//            }
//            return noteArray
//
//        }
    
    func addTofolderArray(note: Note) {
        noteArray.append(note)
    }
    
    func viewWillDisappear() {
        guard realm.object(ofType: Folder.self, forPrimaryKey: folderObject.serialNumber) != nil else { return }
        try! realm.write {

            folderObject.notes.append(note)
        }
    
    }
}

