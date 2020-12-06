//
//  Note.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit

public class Note: NSObject {
    
    var userInput: String?
    var serialNumber: String?
    var dateCreated: Date
    
    
    init(userInput: String?) {
        let uniqueSerialNumber =
        UUID().uuidString.components(separatedBy: "-").first!
        self.userInput = userInput
        self.dateCreated = Date()
        self.serialNumber = uniqueSerialNumber
    }
    
}
