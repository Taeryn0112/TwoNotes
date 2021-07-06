//
//  SectionItem.swift
//  TwoNotes
//
//  Created by Terry Lee on 6/30/21.
//

import Foundation

class SectionItem {
    var name: String!
    var folders: [Folder]!
    
    init() {
        name = ""
        folders = []
    }
    
    init(name: String, folders: [Folder]) {
        self.name = name
        self.folders = folders
    }
    
//    static let example = [
//        SectionItem(name: "Favorites", folders: <#[Folder]#>),
//        SectionItem(name: "Gmail", folders: <#[Folder]#>)
//    ]
}
