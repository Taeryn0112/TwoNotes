//
//  NotesTableViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit
import Foundation

public class NotesTableViewController: UITableViewController {
    
    var noteStore: NoteStore!
    
    @IBAction func addNewNote(_ sender: UIButton) {
        
        let newNote = noteStore.storeNote()
        
        if let index = noteStore.allNote.firstIndex(of: newNote) {
            let indexPath = IndexPath(row: index, section: 0)
            
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
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
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return noteStore.allNote.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        
        let note = noteStore.allNote[indexPath.row]
        cell.textLabel?.text = note.userInput
        cell.detailTextLabel?.text = "\(note.serialNumber)"
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
    
}
