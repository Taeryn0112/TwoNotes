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
    
    var noteObject: Note!
    var notes = SceneDelegate.realm
    var notesTVC: NotesTableViewController!
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        try! notes.write {
            
            guard let userInput = notes.object(ofType: Note.self, forPrimaryKey: noteObject.serialNumber) else { return }
            
            let userInputText = noteTextView.text
            noteObject.userInput = userInputText
            
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        print(noteObject.serialNumber)
        
        noteTextView.text = noteObject.userInput
    }
    
    
    
    @objc public func doneTapped() {
        print("done")
        noteTextView.resignFirstResponder()
    }
    
    
}


