//
//  FolderViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 6/1/21.
//

import UIKit
import Foundation

class FolderViewController: UIViewController, UISearchBarDelegate {
    
    var notesMainViewController: NotesMainViewController!
    @IBOutlet weak var folderSearchBar: UISearchBar!
    @IBOutlet weak var folderTableView: UITableView!
    var folderArray = [Folder]()
    public override func viewDidLoad() {
        super.viewDidLoad()
        folderTableView.delegate = self
        folderTableView.dataSource = self
        folderTableView.reloadData()
        
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        folderTableView.reloadData()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        folderTableView.reloadData()
    }
    
    @IBAction func addNewFolder(_ sender: UIButton) {
        let title = "New Folder"
        let message = "Enter the name of the new folder"
        let addFolder = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let addFolderAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        addFolder.addAction(addFolderAction)
        addFolder.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your folder name here..."
        })
        
        addFolder.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            if let folderName = addFolder.textFields?.first?.text {
                print("Your folder name: \(folderName)")
                // Create new folder and set name property
                
                let folder = Folder()
                folder.folderTitle = folderName
                
                // Add to folder array
                self.folderArray.append(folder)
                
                if let index = self.folderArray.firstIndex(of: folder) {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.folderTableView.insertRows(at: [indexPath], with: .automatic)
                    }
                }
            }))
        
        self.folderTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
        present(addFolder, animated: true, completion: nil)
    }
    
    
    //MARK: Segue
    
//    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "showNotes"?:
//            if let row = folderTableView.indexPathForSelectedRow?.row {
//                let folder = self.noteFolder[row]
//                let notesViewController = segue.destination as! NotesMainViewController
////                notesViewController.viewModel = NoteDetailViewModel(note: notes)
//
//            }
//        case "addNewFolder"?:
//            let newNote = Note(userInput: "")
//            noteStore.storeNote(newNote)
//            self.filteredNote.append(newNote)
//
//            if let index = filteredNote.firstIndex(of: newNote) {
//                let indexPath = IndexPath(row: index, section: 0)
//                self.noteTableView.insertRows(at: [indexPath], with: .automatic)
//
//
//            }

//            let notesViewController = segue.destination as! NoteDetailViewController
//
//            notesViewController.viewModel = NoteDetailViewModel(note: newNote)
//        default:
//            preconditionFailure("Unexpected segue identifier")
//        }
//    }
    
}

extension FolderViewController : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as! FolderCell
        let folder = folderArray[indexPath.row]
    
        cell.folderTitleLabel.text = folder.folderTitle
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            let notes = noteStore.allNote[indexPath.row]
//            let note = filteredNote[indexPath.row]
//            let title = "Delete \(notes.userInput ?? "")"
//            let message = "Are you sure you want to delete this note?"
//            
//            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            ac.addAction(cancelAction)
//            
//            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
//                
//                self.noteStore.deleteNote(note)
//                self.deleteNote(note)
//                self.noteTableView.deleteRows(at: [indexPath], with: .automatic)
//                
//                
//            })
//            ac.addAction(deleteAction)
//            
//            present(ac, animated: true, completion: nil)
//        }
//        
//    }
//
//    public func deleteNote(_ note: Note) {
//        
//        if let index = filteredNote.firstIndex(of: note) {
//            filteredNote.remove(at: index)
//        }
//        
//    }
//    
//    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        self.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
//        noteStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
//        tableView.reloadData()
//    }
//    
//    func moveItem(from fromIndex: Int, to toIndex: Int) {
//        if fromIndex == toIndex {
//            return
//        }
//        
//        let originalNote = filteredNote[fromIndex]
//
//        filteredNote.remove(at: fromIndex)
//        filteredNote.insert(originalNote, at: toIndex)
//        
//        noteTableView.reloadData()
//
//    }
    
//    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // When there is no text, filteredData is the same as the original data
//        // When user has entered text into the search box
//        // Use the filter method to iterate over all items in the data array
//        // For each item, return true if the item should be included and false if the
//        // item should NOT be included
//        filteredNote = searchText.isEmpty ? noteStore.allNote : noteStore.allNote.filter { (note: Note) -> Bool in
//            // If dataItem matches the searchText, return true to include it
//            return note.noteTitle?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil || note.userInput?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//        }
//
//        noteTableView.reloadData()
//    }
    
}
