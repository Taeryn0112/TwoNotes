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

    var viewModel: FolderDetailViewModel!
    var realm = SceneDelegate.realm
    //    let folder = Folder()
    var folderStore = FolderStore()
    var folders: Results<Folder>!
    var filteredFolder = [Folder]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        folderTableView.delegate = self
        folderTableView.dataSource = self
        folderSearchBar.delegate = self
        
        let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showEditing(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
        rightButton.tintColor = UIColor.black
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredFolder = folderStore.allFolder
        folderTableView.reloadData()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        folderTableView.reloadData()
    }
    
    @objc func showEditing(sender: UIBarButtonItem) {
        if(self.folderTableView.isEditing == true) {
            self.folderTableView.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            
        } else
        {
            self.folderTableView.isEditing = true
            self.navigationItem.rightBarButtonItem?.title = "Done"
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
                self.filteredFolder = self.folderStore.allFolder
                
                if let index = self.filteredFolder.firstIndex(of: folder) {
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
                let folder = self.filteredFolder[row]
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
        return filteredFolder.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as! FolderCell
        let folder = filteredFolder[indexPath.row]
    
        cell.folderTitleLabel.text = folder.folderTitle
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let folder = folderStore.allFolder[indexPath.row]
            let folders = filteredFolder[indexPath.row]
            let title = "Delete \(folder.folderTitle ?? "")"
            let message = "Are you sure you want to delete this note?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                
                self.folderStore.deleteFolder(folder)
                self.deleteFolder(folders)
                self.folderTableView.deleteRows(at: [indexPath], with: .automatic)
                
            })
            ac.addAction(deleteAction)
            
            present(ac, animated: true, completion: nil)
        }
        
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            print("Just swiped added", action)
            
                let title = "Edit Folder"
                let message = "Re-name the folder"
                let addFolder = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let addFolderAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                addFolder.addAction(addFolderAction)
                addFolder.addTextField(configurationHandler: { textField in
                    textField.placeholder = "Input your folder name here..."
                })
                
                addFolder.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
                    if let folderName = addFolder.textFields?.first?.text {
                        print("Your folder name: \(folderName)")
                        // When user re-enters new title then presses Add, grab the existing title and change the title of the folder to the new title.
                        let selectedFolder = self.folderStore.allFolder[indexPath.row]
                        //  Update the folderTitle
                        self.folderStore.updateFolderTitle(selectedFolder, folderName: folderName)
                        print("Selected folder title: \(selectedFolder.folderTitle)")
                        self.folderTableView.reloadData()
                    }
                }))
                
                
    //            addFolder.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
    //                if let folderName = addFolder.textFields?.first?.text {
    //                    print("Your folder name: \(folderName)")
    //                    // Create new folder and set name property
    //                    let folder = Folder()
    //                    folder.folderTitle = folderName
    //
    //                    // Add to folder array
    //                    self.folderStore.storeFolder(folder)
    //                    self.filteredFolder = self.folderStore.allFolder
    //
    //                    if let index = self.filteredFolder.firstIndex(of: folder) {
    //                            let indexPath = IndexPath(row: index, section: 0)
    //                            self.folderTableView.insertRows(at: [indexPath], with: .automatic)
    //
    //                        }
    //                    print("serial number: \(folder.serialNumber)")
    //
    //                    }
    //
    //                }))
    //            }
                
                self.folderTableView.reloadData()
                self.navigationController?.popViewController(animated: true)
                self.present(addFolder, animated: true, completion: nil)
                completion(false)
            
        }

        edit.image = UIImage(systemName: "square.and.pencil")
        edit.backgroundColor = .systemOrange
    
        let config = UISwipeActionsConfiguration(actions: [edit])
        config.performsFirstActionWithFullSwipe = false
        return config
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") {(action, view, completion) in
            print("Just swiped added", action)
            let folder = self.folderStore.allFolder[indexPath.row]
            let folders = self.filteredFolder[indexPath.row]
            let title = "Delete \(folder.folderTitle ?? "")"
            let message = "Are you sure you want to delete this note?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                
                self.folderStore.deleteFolder(folder)
                self.deleteFolder(folders)
                self.folderTableView.deleteRows(at: [indexPath], with: .automatic)
                
            })
            ac.addAction(deleteAction)
            
            self.present(ac, animated: true, completion: nil)
            completion(false)
        }
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    
    public func deleteFolder(_ folder: Folder) {
        
        if let index = filteredFolder.firstIndex(of: folder) {
            filteredFolder.remove(at: index)
        }
        
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.moveFolder(from: sourceIndexPath.row, to: destinationIndexPath.row)
        folderStore.moveFolder(from: sourceIndexPath.row, to: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func moveFolder(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let originalFolder = filteredFolder[fromIndex]

        filteredFolder.remove(at: fromIndex)
        filteredFolder.insert(originalFolder, at: toIndex)
        
        folderTableView.reloadData()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        
        if searchText.isEmpty {
            filteredFolder = folderStore.allFolder
        } else {
            filteredFolder = searchText.isEmpty ? filteredFolder : filteredFolder.filter { (folder: Folder) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return folder.folderTitle.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                    }
            }
             folderTableView.reloadData()
        }
    
}

