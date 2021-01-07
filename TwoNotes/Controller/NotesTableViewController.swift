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
    
    var notesViewController: NotesViewController!
    var noteStore: NoteStore!
    
    
    //MARK: Views
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
    
    //MARK: TableViews
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteStore.allNote.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        let note = noteStore.allNote[indexPath.row]
        cell.userInputLabel.text = note.userInput
        cell.detailTextLabel?.text = nil
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let notes = noteStore.allNote[indexPath.row]
            
            let title = "Delete \(notes.userInput)"
            let message = "Are you sure you want to delete this note?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                
//                try! self.realm.write {
//                    self.realm.delete(notes)
//
//                }
                self.noteStore.deleteNote(notes)
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            present(ac, animated: true, completion: nil)
        }
        
    }

    public override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        noteStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        tableView.reloadData()
        print(noteStore.allNote)
    }
    
    //MARK: Segue
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showNote"?:
            if let row = tableView.indexPathForSelectedRow?.row {
//                try! self.notes.write {
//
//                    self.note.realm?.objects(Note.self)
//
//                }
                
                let notes = noteStore.allNote[row]
                let notesViewController = segue.destination as! NotesViewController
                notesViewController.noteObject = notes
                
            }
        case "addNewNote"?:
            
            let newNote = Note(userInput: "")
            
            noteStore.storeNote(newNote)
            if let index = noteStore.allNote.firstIndex(of: newNote) {
                let indexPath = IndexPath(row: index, section: 0)
                
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            let notesViewController = segue.destination as! NotesViewController
                  
            notesViewController.noteObject = newNote
            
        default: preconditionFailure("Unexpected segue identifier")
        }
    }
    
}

