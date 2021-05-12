//
//  NoteDetailViewModel.swift
//  TwoNotes
//
//  Created by Terry Lee on 3/16/21.
//

import Foundation
import RealmSwift

class NoteDetailViewModel  {
    
    var noteObject: Note!
    var realm = SceneDelegate.realm
    var noteDetailVC: NoteDetailViewController!
    
    init(note: Note) {
        self.noteObject = note
    }
    
    var noteText: String {
        return noteObject.userInput ?? ""
    }
    
    var titleText: String {
        return noteObject.noteTitle ?? ""
    }
    
    var dateText: String {
        return DateUtils.shared.string(from: noteObject.date)
    }
    
    func viewWillDisappear(noteText: String, titleText: String) {
        guard realm.object(ofType: Note.self, forPrimaryKey: noteObject.serialNumber) != nil else { return }
        try! realm.write {
            noteObject.userInput = noteText
            noteObject.noteTitle = titleText
        }
    }
    
    func textDidChange() {
        // Current date needs to be saved in Realm so it can be updated everytime user edits.
        let today = Date()
        try! realm.write {
            noteObject.date = today
        }
    }
}
