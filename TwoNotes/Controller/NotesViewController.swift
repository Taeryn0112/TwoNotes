//
//  NotesViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit
import RealmSwift

public class NotesViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var noteTextView: UITextView!
    
        var note: Note!
        
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let userInputText = noteTextView.text
        
        note.userInput = userInputText
        note.save()
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noteTextView.text = note.userInput
    }
    
    @objc public func doneTapped() {
        print("done")
        noteTextView.resignFirstResponder()
    }
    
    
}


