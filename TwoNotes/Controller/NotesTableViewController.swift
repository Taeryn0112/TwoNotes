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
    
}
