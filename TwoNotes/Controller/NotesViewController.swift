//
//  NotesViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit

public class NotesViewController: UIViewController {
    @IBOutlet weak var noteTextView: UITextView!
    
        var note: Note!
        
    @IBAction func done(_ sender: Any) {
        note.userInput = noteTextView.text
        dismiss(animated: true, completion: nil)
    }
    
}
