//
//  Folder.swift
//  TwoNotes
//
//  Created by Terry Lee on 6/8/21.
//

import UIKit
import RealmSwift

class Folder: Object {
    
    @objc dynamic var folderTitle: String! = nil
    // var notes: [Note]
    @objc dynamic var serialNumber = ObjectId.generate()
    @objc dynamic var orderingValue: Int = 0
    let notes = List<Note>()
    @objc dynamic var isFavorited: Bool = false
    
    convenience init(folderName folderTitle: String) {
        self.init()
        self.folderTitle = folderTitle
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
