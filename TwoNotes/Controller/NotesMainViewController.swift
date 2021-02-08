//
//  NotesTableViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit
import Foundation
import RealmSwift


public class NotesMainViewController: UIViewController{
    
    var notesViewController: NotesViewController!
    var noteStore: NoteStore!
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var addNoteButtonView: UIView!
    
    //MARK: Views
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        startObserving(&UserInterfaceStyleManager.shared)
        self.title = "Two Notes"
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteTableView.reloadData()

        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noteTableView.reloadData()
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        noteTableView.reloadData()
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        if isEditing {
            
        sender.setTitle("Edit", for: .normal)
        
        setEditing(false, animated: true)
        } else {
            
            sender.setTitle("Done", for: .normal)
            
            setEditing(true, animated: true)
        }
    }
    
    
    //MARK: Segue
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showNote"?:
            if let row = noteTableView.indexPathForSelectedRow?.row {
                
                let notes = noteStore.allNote[row]
                let notesViewController = segue.destination as! NotesViewController
                notesViewController.noteObject = notes
            }
        case "addNewNote"?:
            
            let newNote = Note(userInput: "")
            noteStore.storeNote(newNote)
            
            if let index = noteStore.allNote.firstIndex(of: newNote) {
                let indexPath = IndexPath(row: index, section: 0)
                
                self.noteTableView.insertRows(at: [indexPath], with: .automatic)
                
            }
            let notesViewController = segue.destination as! NotesViewController
                  
            notesViewController.noteObject = newNote
            
        default: preconditionFailure("Unexpected segue identifier")
        }
    }
}

extension NotesMainViewController: UITableViewDelegate, UITableViewDataSource  {
    
    //MARK: TableViews
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteStore.allNote.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        let note = noteStore.allNote[indexPath.row]
        cell.noteDetailLabel.text = note.userInput
        cell.detailTextLabel?.text = nil
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let notes = noteStore.allNote[indexPath.row]
            
            let title = "Delete \(notes.userInput ?? "")"
            let message = "Are you sure you want to delete this note?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                
                self.noteStore.deleteNote(notes)
                self.noteTableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            present(ac, animated: true, completion: nil)
        }
        
    }

    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        noteStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        tableView.reloadData()
        
    }
    
}
