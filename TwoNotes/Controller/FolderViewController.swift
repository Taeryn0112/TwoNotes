//
//  FolderViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 6/1/21.
//

import UIKit
import Foundation
import RealmSwift

class FolderViewController: UIViewController, UISearchBarDelegate {
    
    var notesMainViewController: NotesMainViewController!
    @IBOutlet weak var folderSearchBar: UISearchBar!
    @IBOutlet weak var folderTableView: UITableView!
//  var folderArray = [Folder]()
    var viewModel: FolderDetailViewModel!
    var realm = SceneDelegate.realm
    //    let folder = Folder()
    var folderStore = FolderStore()
    var folders: Results<Folder>!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        folderTableView.delegate = self
        folderTableView.dataSource = self
        
        let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showEditing(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
        rightButton.tintColor = UIColor.black
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        folderTableView.reloadData()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        folderTableView.reloadData()
    }
    
    @objc func showEditing(sender: UIBarButtonItem) {
        if(self.folderTableView.isEditing == true) {
            self.folderTableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        } else
        {
            self.folderTableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }
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
                self.folderStore.storeFolder(folder)
                
                if let index = self.folderStore.allFolder.firstIndex(of: folder) {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.folderTableView.insertRows(at: [indexPath], with: .automatic)
                        
                    }
                print("serial number: \(folder.serialNumber)")
               
                }
            
            }))

        self.folderTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
        present(addFolder, animated: true, completion: nil)
    }
    
    
    //MARK: Segue
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showFolderContent"?:
            if let row = folderTableView.indexPathForSelectedRow?.row {
                let folder = self.folderStore.allFolder[row]
                let notesMainViewController = segue.destination as! NotesMainViewController
                // Create a FolderDetailViewModel instance and set it to local variable called viewModel
                let viewModel =  FolderDetailViewModel(folder: folder)
                notesMainViewController.viewModel = viewModel
                
                print("serial number: \(folder.serialNumber)")
            }

        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
}

extension FolderViewController : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderStore.allFolder.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as! FolderCell
        let folder = folderStore.allFolder[indexPath.row]
    
        cell.folderTitleLabel.text = folder.folderTitle
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        
            let folder = folderStore.allFolder[indexPath.row]
            let title = "Delete \(folder.folderTitle ?? "")"
            let message = "Are you sure you want to delete this note?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                
                self.folderStore.deleteFolder(folder)
                self.deleteFolder(folder)
                self.folderTableView.deleteRows(at: [indexPath], with: .automatic)
                
            })
            ac.addAction(deleteAction)
            
            present(ac, animated: true, completion: nil)
        }
        
    }

    public func deleteFolder(_ folder: Folder) {
        
        if let index = folderStore.allFolder.firstIndex(of: folder) {
            folderStore.allFolder.remove(at: index)
        }
        
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        self.moveFolder(from: sourceIndexPath.row, to: destinationIndexPath.row)
        folderStore.moveFolder(from: sourceIndexPath.row, to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func moveFolder(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let originalFolder = folderStore.allFolder[fromIndex]

        folderStore.allFolder.remove(at: fromIndex)
        folderStore.allFolder.insert(originalFolder, at: toIndex)
        
        folderTableView.reloadData()
    }
    
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

