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
    var noteArray = [Note]()
    var note: Note!
    var sortedArray: Results<Note> {
        return realm.objects(Note.self).filter("folderSerialNumber = %@", folderObject.serialNumber)
    }
    
    init(folder: Folder) {
        self.folderObject = folder
        
    }
    
    var folderTitleText: String {
        return folderObject.folderTitle ?? ""
    }
    
    func viewDidLoad() {
        
        let sortByOrderArray = sortedArray.sorted(byKeyPath: "orderingValue", ascending: true)

        self.noteArray.insert(contentsOf: sortByOrderArray, at: 0)
        
    }
    
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

