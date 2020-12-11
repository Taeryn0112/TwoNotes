//
//  NotesTableViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit
import Foundation
import RealmSwift

public class NotesTableViewController: UITableViewController {
    
    var noteStore: NoteStore!
    var notesViewController: NotesViewController!
    //MARK: Views
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
//        DispatchQueue.main.async {
//            self.getNotesObject(for: Date())
//        }
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK: TableViews
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return noteStore.allNote.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        
        let note = noteStore.allNote[indexPath.row]
        cell.userInputLabel.text = note.userInput
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let note = noteStore.allNote[indexPath.row]
            
            let title = "Delete \(note.userInput)"
            let message = "Are you sure you want to delete this note?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                
                self.noteStore.removeNote(note)
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
           
            present(ac, animated: true, completion: nil)
        }
        
    }

    public override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        noteStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showNote"?:
            if let row = tableView.indexPathForSelectedRow?.row {
                let note = noteStore.allNote[row]
                let notesViewController = segue.destination as! NotesViewController
                notesViewController.note = note
            }
        case "addNewNote"?:
            let newNote = Note(userInput: "")
            noteStore.storeNote(newNote)
            if let index = noteStore.allNote.firstIndex(of: newNote) {
                let indexPath = IndexPath(row: index, section: 0)
                
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            let notesViewController = segue.destination as! NotesViewController
                  
            notesViewController.note = newNote
            
        default: preconditionFailure("Unexpected segue identifier")
        }
    }
    
}
