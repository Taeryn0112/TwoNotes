//
//  Note.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit
import RealmSwift

public class Note: Object {
    @objc dynamic var userInput: String? = nil
    @objc dynamic var noteTitle: String? = nil
    @objc dynamic var serialNumber = ObjectId.generate()
    @objc dynamic var orderingValue: Int = 0
    @objc dynamic var date: Date! = Date()
    
    
    convenience init(userInput: String?) {
        self.init()
        self.userInput = userInput
    }
    
    public override static func primaryKey() -> String? {
        return "serialNumber"
    }
}
