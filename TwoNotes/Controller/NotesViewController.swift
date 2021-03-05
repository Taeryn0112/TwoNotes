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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesDateLabel: UILabel!
    var noteObject: Note!
    var realm = SceneDelegate.realm
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        try! realm.write {

            guard let userInput = realm.object(ofType: Note.self, forPrimaryKey: noteObject.serialNumber) else { return }
            let userInputText = noteTextView.text
            noteObject.userInput = userInputText
            let titleText = titleTextField.text
            noteObject.noteTitle = titleText
            
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        
        startObserving(&UserInterfaceStyleManager.shared)
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noteTextView.text = noteObject.userInput
        titleTextField.text = noteObject.noteTitle
        
        // Date format ex. Wednesday 12:00 PM
        
        let today = Date()
        let dateFormatter = DateFormatter()
        let weekday = Calendar.current.component(.weekday, from: today)
        dateFormatter.dateFormat = "h:mm a"
        let dateInString = dateFormatter.string(from: today as Date)
        notesDateLabel.text = Calendar.current.weekdaySymbols[weekday-1] + " \(dateInString)"
        
    }
    
    @objc public func doneTapped() {
        print("done")
        noteTextView.resignFirstResponder()
        titleTextField.resignFirstResponder()
    }
    
    
}


