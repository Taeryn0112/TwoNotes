//
//  Note.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit

public class Note: NSObject {
    
    var userInput: String
    var serialNumber: String?
    var dateCreated: Date
    
    init(userInput: String, serialNumber: String?) {
        self.userInput = userInput
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        
    }
    
    convenience init(random: Bool = false) {
        
        if random {
        let words = ["word1", "word2", "word3"]

        let idx = arc4random_uniform(UInt32(words.count))
        let randomWords = words[Int(idx)]
        
        let randomInput = "\(randomWords)"
        
        let uniqueSerialNumber =
        UUID().uuidString.components(separatedBy: "-").first!
        
        self.init(userInput: randomInput , serialNumber: uniqueSerialNumber)
            
        }
        else {
            self.init(userInput: "", serialNumber: nil)
        }
    }
}
