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
    @objc dynamic var serialNumber: String? = nil
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
    
    //MARK: Realm functions
    
    func fetchNotesFromDataBase() -> Results<Note> {
        
        let notes = realm?.objects(Note.self)
        return notes!
    }
    
    func save() {
        let realm = SceneDelegate.realm
        try! realm.write() {
            realm.add(self)
        }
    }
    
}
