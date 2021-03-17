//
//  NotesViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit
import RealmSwift


public class NoteDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesDateLabel: UILabel!
    var viewModel: NoteDetailViewModel!

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear(noteText: noteTextView.text, titleText: titleTextField.text ?? "")
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
        noteTextView.text = viewModel.noteText
        titleTextField.text = viewModel.titleText
        notesDateLabel.text = viewModel.dateText 
    }
    
    @objc public func doneTapped() {
        print("done")
        noteTextView.resignFirstResponder()
        titleTextField.resignFirstResponder()
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let today = Date()
        notesDateLabel.text = DateUtils.shared.string(from: today)
        viewModel.textDidChange()
    }
    
    @objc public func textFieldDidChange(_ textField: UITextField) {
        let today = Date()
        notesDateLabel.text = DateUtils.shared.string(from: today)
        viewModel.textDidChange()
    }
}
