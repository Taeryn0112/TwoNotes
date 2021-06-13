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
    
    init(folder: Folder) {
        self.folderObject = folder
    }
    
    var folderTitleText: String {
        return folderObject.folderTitle ?? ""
    }
    
    func viewWillDisappear(titleText: String) {
        guard realm.object(ofType: Folder.self, forPrimaryKey: folderObject.serialNumber) != nil else { return }
        try! realm.write {
        
            folderObject.folderTitle = titleText
        }
    }
}

