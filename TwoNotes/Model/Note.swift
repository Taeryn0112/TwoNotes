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
    var serialNumber: String?
    var dateCreated: Date
    
    override init() {
        let uniqueSerialNumber =
        UUID().uuidString.components(separatedBy: "-").first!
        
        self.dateCreated = Date()
        self.serialNumber = uniqueSerialNumber
    }
    
    convenience init(userInput: String?) {
        self.init()
        self.userInput = userInput
        
    }
    
    func save() {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(self)
        }
    }
    
}
