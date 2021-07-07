//
//  FolderStore.swift
//  TwoNotes
//
//  Created by Terry Lee on 6/12/21.
//

import UIKit
import RealmSwift

public class FolderStore {
    static let shared = FolderStore() 
    private let realm = try! Realm()
    
    var allFolder = [Folder]()
    var favoritesFolder = [Folder]()
    var defaultFolder = [Folder]()
    var sectionItems = [SectionItem]()

    init() {
        self.fetchFoldersFromDataBase()
    }
    
    private func fetchFoldersFromDataBase() {
        let folders = Array(realm.objects(Folder.self).sorted(byKeyPath: "orderingValue", ascending: true))
        self.allFolder = folders
        favoritesFolder = self.allFolder.filter({ folder -> Bool in
            return folder.isFavorited
        })
        defaultFolder = self.allFolder
        
//
        updateFavoriteFolderOrderingValue()
        updateDefaultFolderOrderingValue()
        
        sectionItems = [
            SectionItem(name: "Favorites", folders: favoritesFolder),
            SectionItem(name: "Gmail", folders: defaultFolder) ]
        
    }
    
    public func fetchFavoriteAndUnfavorite() {
        
        let folders = Array(realm.objects(Folder.self).sorted(byKeyPath: "orderingValue", ascending: true))
        self.allFolder = folders
        favoritesFolder = self.allFolder.filter({ folder -> Bool in
            return folder.isFavorited
        })
        defaultFolder = self.allFolder

        updateFavoriteFolderOrderingValue()
        updateDefaultFolderOrderingValue()
        
        sectionItems = [
            SectionItem(name: "Favorites", folders: favoritesFolder),
            SectionItem(name: "Gmail", folders: defaultFolder) ]
        
    }
    
    private func saveFolder(_ folder: Folder) {
        try! realm.write {
            realm.add(folder)
        }
    }

    func updateFolderTitle(_ folder: Folder, folderName: String) {
        try! realm.write {
        // Update folder name
        folder.folderTitle = folderName
      }
        updateFolderOrderingValue()
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
    
    func deleteDefaultFolder(_ folder: Folder) {
        try! self.realm.write {
            self.realm.delete(folder)
        }
        // remove the note from allFolder
        if let index = sectionItems[1].folders.firstIndex(of: folder) {
            sectionItems[1].folders.remove(at: index)
            
        }
        // update ordering value
        updateDefaultFolderOrderingValue()
    }
    
    func deleteFavoritesFolder(_ folder: Folder) {
//        try! self.realm.write {
//            self.realm.delete(folder)
//        }
        // remove the note from allFolder
        if let index = favoritesFolder.firstIndex(of: folder) {
            favoritesFolder.remove(at: index)
            
        }
        // update ordering value
        updateFavoriteFolderOrderingValue()
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
    

    
    public func updateDefaultFolderOrderingValue() {
        try! realm.write {
            for folder in defaultFolder {
                if let index = defaultFolder.firstIndex(of: folder) {
                    folder.orderingValue = index
                }
            }
        }
    }
    
    public func updateFavoriteFolderOrderingValue() {
        try! realm.write {
            for folder in favoritesFolder {
                if let index = favoritesFolder.firstIndex(of: folder) {
                    folder.orderingValue = index
                }
            }
        }
    }
    
    func toggleFavoriteState(_ favorite: Folder) {
            try! self.realm.write {
                if favorite.isFavorited == false {
                favorite.isFavorited = true
                    }
                else if favorite.isFavorited == true {
                    favorite.isFavorited = false
                }
            }
        
    }

    
}
