//
//  NotesViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit
import RealmSwift

public class NotesViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
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
        noteTextView.delegate = self
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noteTextView.text = noteObject.userInput
        titleTextField.text = noteObject.noteTitle
        
        // Date format ex. Wednesday 12:00 PM

        let dateFormatter = DateFormatter()
        let weekday = Calendar.current.component(.weekday, from: noteObject.date)
        dateFormatter.dateFormat = "h:mm a"
        let dateInString = dateFormatter.string(from: noteObject.date as Date)
        notesDateLabel.text = Calendar.current.weekdaySymbols[weekday-1] + " \(dateInString)"
        
    }
    
    @objc public func doneTapped() {
        print("done")
        noteTextView.resignFirstResponder()
        titleTextField.resignFirstResponder()
    
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        
        let today = Date()
        let dateFormatter = DateFormatter()
        let weekday = Calendar.current.component(.weekday, from: today)
        dateFormatter.dateFormat = "h:mm a"
        let dateInString = dateFormatter.string(from: today as Date)
        notesDateLabel.text = Calendar.current.weekdaySymbols[weekday-1] + " \(dateInString)"
        
        // Current date needs to be saved in Realm so it can be updated everytime user edits.
        
        try! realm.write {
        noteObject.date = today
            }
        }
    
    @objc public func textFieldDidChange(_ textField: UITextField) {
         
        let today = Date()
        let dateFormatter = DateFormatter()
        let weekday = Calendar.current.component(.weekday, from: today)
        dateFormatter.dateFormat = "h:mm a"
        let dateInString = dateFormatter.string(from: today as Date)
        notesDateLabel.text = Calendar.current.weekdaySymbols[weekday-1] + " \(dateInString)"
        
        try! realm.write {
        noteObject.date = today
            }
    }
    
}


