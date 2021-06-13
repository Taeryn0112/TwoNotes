//
//  FolderStore.swift
//  TwoNotes
//
//  Created by Terry Lee on 6/12/21.
//

import UIKit
import RealmSwift

public class FolderStore {
    private let realm = try! Realm()
    var allFolder = [Folder]()
    var folderTitle: String!
    
    init() {
        self.fetchFoldersFromDataBase()
    }
    
    private func fetchFoldersFromDataBase() {
        let folders = Array(realm.objects(Folder.self).sorted(byKeyPath: "orderingValue", ascending: true))
        self.allFolder = folders
    }
    
    
    private func saveFolder(_ folder: Folder) {
        try! realm.write {
            realm.add(folder)
        }
    }

    
    func deleteFolder(_ folder: Folder) {
        try! self.realm.write {
            self.realm.delete(folder)
        }
        // remove the note from allFolder
        if let index = allFolder.firstIndex(of: folder) {
            allFolder.remove(at: index)
            
        }
        // update ordering value
        updateFolderOrderingValue()
    }
    
    
    func storeFolder(_ folder: Folder) {
        saveFolder(folder)
        allFolder.insert(folder, at: 0)
        updateFolderOrderingValue()
    }
    
    
    func moveFolder(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let originalFolder = allFolder[fromIndex]
        
        allFolder.remove(at: fromIndex)
        allFolder.insert(originalFolder, at: toIndex)
        
        updateFolderOrderingValue()
    }
    
    private func updateFolderOrderingValue() {
        try! realm.write {
            for folder in allFolder {
                if let index = allFolder.firstIndex(of: folder) {
                    folder.orderingValue = index
                }
            }
        }
    }
    
    
}
