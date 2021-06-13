//
//  Folder.swift
//  TwoNotes
//
//  Created by Terry Lee on 6/8/21.
//

import UIKit
import RealmSwift

class Folder: Object {
    
    @objc dynamic var folderTitle: String!
    // var notes: [Note]
    @objc dynamic var serialNumber = ObjectId.generate()
    @objc dynamic var orderingValue: Int = 0
//    let note = List<Note>()
    
    override init() {
        self.folderTitle = ""
//        self.notes = []
    }
    
    init(folderName folderTitle: String) {
        self.folderTitle = folderTitle
//        self.notes = []
    }
    
    public override static func primaryKey() -> String? {
        return "serialNumber"
    }
}

extension Folder {
    
    static func == (lhs: Folder, rhs: Folder) -> Bool {
        return lhs.folderTitle == rhs.folderTitle
    }
}
