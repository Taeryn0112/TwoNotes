//
//  NotesTableViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit
import Foundation
import RealmSwift

public class NotesMainViewController: UIViewController, UIImagePickerControllerDelegate, UISearchBarDelegate {
    
    var notesDetailViewController: NoteDetailViewController!
    var noteStore = NoteStore()
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var addNoteButtonView: UIView!
    @IBOutlet weak var noteSearchBar: UISearchBar!
    var note: Note!
    var filteredNote: [Note]!
    var viewModel: FolderDetailViewModel!
    var folder: Folder!
    //MARK: Views
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        startObserving(&UserInterfaceStyleManager.shared)
        self.title = viewModel.folderTitleText
        noteTableView.delegate = self
        noteTableView.dataSource = self
        noteSearchBar.delegate = self
        
        let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showEditing(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
        rightButton.tintColor = UIColor.black
        
        viewModel.viewDidLoad()
        noteTableView.reloadData()
        }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredNote = viewModel.noteArray
        
        noteTableView.reloadData()
       
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        noteTableView.reloadData()
    }
    
    @objc func showEditing(sender: UIBarButtonItem) {
        if(self.noteTableView.isEditing == true) {
            self.noteTableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        } else
        {
            self.noteTableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }
    }
    

    //MARK: Segue
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showNoteContent"?:
            if let row = noteTableView.indexPathForSelectedRow?.row {
                let notes = self.viewModel.noteArray[row]
                let notesViewController = segue.destination as! NoteDetailViewController
                notesViewController.viewModel = NoteDetailViewModel(note: notes)
                
                self.noteTableView.reloadData()
            }
        case "addNewNote"?:
            let newNote = Note(userInput: "")
            newNote.folderSerialNumber = viewModel.folderObject.serialNumber
            noteStore.storeNote(newNote)
            self.viewModel.noteArray.insert(newNote, at: 0)
            
            if let index = viewModel.noteArray.firstIndex(of: newNote) {
                let indexPath = IndexPath(row: index, section: 0)
                self.noteTableView.insertRows(at: [indexPath], with: .automatic)
                
            }
            
            let notesViewController = segue.destination as! NoteDetailViewController
            
            notesViewController.viewModel = NoteDetailViewModel(note: newNote)
            self.noteTableView.reloadData()
            
            
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}

extension NotesMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableViews
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.noteArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        let note = viewModel.noteArray[indexPath.row]
        
        cell.noteDetailLabel.text = note.userInput
        cell.noteTitleLabel.text = note.noteTitle
        cell.noteDateLabel.text = DateUtils.shared.noteString(from: note.date)
        cell.detailTextLabel?.text = nil
        return cell
    }
        
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let notes = noteStore.allNote[indexPath.row]
            let note = viewModel.noteArray[indexPath.row]
            let title = "Delete \(notes.userInput ?? "")"
            let message = "Are you sure you want to delete this note?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                
                self.noteStore.deleteNote(notes)
                self.deleteNote(note)
                self.noteTableView.deleteRows(at: [indexPath], with: .automatic)
                
            })
            ac.addAction(deleteAction)
            
            present(ac, animated: true, completion: nil)
        }
        
    }

    public func deleteNote(_ note: Note) {
        
        if let index = viewModel.noteArray.firstIndex(of: note) {
            viewModel.noteArray.remove(at: index)
        }
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        noteStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        self.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let originalNote = viewModel.noteArray[fromIndex]

        viewModel.noteArray.remove(at: fromIndex)
        viewModel.noteArray.insert(originalNote, at: toIndex)
        
        noteTableView.reloadData()

    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        
        if searchText.isEmpty {
//          If search text is empty,
//          grab the original unfiltered viewModel.noteArray
//          and display it on the noteTableView.
            let sortedArray = Array(viewModel.sortedArray)
            viewModel.noteArray = sortedArray
            noteTableView.reloadData()
        } else {
            // Else search text is not empty
            // filter notes based on search user input
            // and display it on the noteTableView.
            viewModel.noteArray = viewModel.noteArray.filter { (note: Note) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return note.noteTitle?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil || note.userInput?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            noteTableView.reloadData()
        }
    }
}
