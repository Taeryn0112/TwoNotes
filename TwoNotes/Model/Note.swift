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
    @objc dynamic var serialNumber = ObjectId.generate()
    @objc dynamic var orderingValue = 0
    
    convenience init(userInput: String?) {
        self.init()
        self.userInput = userInput
    }
    
    public override static func primaryKey() -> String? {
        return "serialNumber"
    }
}
