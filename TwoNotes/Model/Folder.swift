//
//  Folder.swift
//  TwoNotes
//
//  Created by Terry Lee on 6/8/21.
//

import UIKit

class Folder: Equatable {
    static func == (lhs: Folder, rhs: Folder) -> Bool {
        return lhs.folderTitle == rhs.folderTitle
    }
    
    var folderTitle: String!
    var notes: [Note]
    
    init() {
        self.folderTitle = ""
        self.notes = []
    }
    
    init(folderTitle: String) {
        self.folderTitle = folderTitle
        self.notes = []
    }
    
    
    
}
