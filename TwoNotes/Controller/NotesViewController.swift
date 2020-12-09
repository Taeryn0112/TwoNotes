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
        
        let realm = try! Realm()
        var userInputText = noteTextView.text
        
        note.userInput = userInputText
        
//        try! realm.write {
//            realm.add(note)
//        }
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
    }
    
    @objc public func doneTapped() {
        print("done")
        noteTextView.resignFirstResponder()
    }
    
}


