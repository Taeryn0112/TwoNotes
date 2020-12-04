//
//  NotesViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit

public class NotesViewController: UITextView {
    
    
    var userText = UITextView()
    
    func textInput() -> String {
        
        guard let text = userText.text else {
            return "No text"
        }
        return text
    }
    
    
}
