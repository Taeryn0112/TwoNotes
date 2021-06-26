//
//  FolderViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 6/1/21.
//

import UIKit
import Foundation
import RealmSwift
import Kingfisher

class FolderViewController: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    var notesMainViewController: NotesMainViewController!
    @IBOutlet weak var folderSearchBar: UISearchBar!
    @IBOutlet weak var folderTableView: UITableView!

    var viewModel: FolderDetailViewModel!
    var realm = SceneDelegate.realm
    //    let folder = Folder()
    var folderStore = FolderStore()
    var folders: Results<Folder>!
    var filteredFolder = [Folder]()
    var sections = ["Gmail"]
    let doubleTapRecognizer = UITapGestureRecognizer(target: self,
        action: #selector(doubleTap(_:)))
    var isFavorited: Bool = true
    var folder: Folder!
    var heart = "heart.png"
    var favoritedHeart = "heartFilled.png"
    
    @IBOutlet weak var kfImageView: UIImageView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        folderTableView.delegate = self
        folderTableView.dataSource = self
        folderSearchBar.delegate = self
        
        
        let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showEditing(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
        rightButton.tintColor = UIColor.black
       
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        
    }
    
    func saveImage(imageName: String, image: UIImage) {

     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }

    func loadImageFromDiskWith(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
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
    
    //MARK: Folder Section
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        return section
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLabel = UILabel()
        headerLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        headerLabel.text = self.tableView(folderTableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    //MARK: TableView Required Methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFolder.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath) as! FolderCell
        let folder = filteredFolder[indexPath.row]
    
        cell.folderTitleLabel.text = folder.folderTitle
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(self.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        cell.addGestureRecognizer(doubleTapRecognizer)
        return cell
    }
    
    //MARK: Edit Folder
    
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
    
    //MARK: Folder Cell Swipe Action Configuration
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: "Favorite") { (action, view, completion) in
            print("Just swipe added", action)
            //When user taps the favorite button once, create Favorite section.  Then copy and move the favorited row under the Favorite section
        }
       
        favorite.backgroundColor = UIColor.systemGray5
        
        // Read the state of the isFavorite property of the selected folder and
        // change the image of favorite accordingly.
        let selectedFolder = folderStore.allFolder[indexPath.row]
        if selectedFolder.isFavorited == false {
            favorite.image = UIImage(named: "heart.png")
        } else
        if selectedFolder.isFavorited == true {
            favorite.image = UIImage(named: "heartFilled.png")
        }
        
        let config = UISwipeActionsConfiguration(actions: [favorite])
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
                
                self.folderTableView.reloadData()
                self.navigationController?.popViewController(animated: true)
                self.present(addFolder, animated: true, completion: nil)
                completion(false)
            
        }

        edit.image = UIImage(systemName: "square.and.pencil")
        edit.backgroundColor = .systemOrange
        
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [delete,edit])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    //MARK: Delete Folder
    
    public func deleteFolder(_ folder: Folder) {
        
        if let index = filteredFolder.firstIndex(of: folder) {
            filteredFolder.remove(at: index)
        }
    }
    
    //MARK: Move Folder
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
    
    //MARK: Search Folder
    
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
    
    //MARK: Folder Gesture Related

    func changeFavoriteToRed(_ favoriteIcon: UIContextualAction) {
        favoriteIcon.image = UIImage(systemName: "heart.fill")?.colored(in: .red)
    }
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        // Get the indexPath of the folder when user double taps on the folder
        guard let indexPath = folderTableView.indexPathForRow(at: gestureRecognizer.location(in: folderTableView)) else {
                print("Error: indexPath")
                return
            }

        let selectedFolder = folderStore.allFolder[indexPath.row]
        if selectedFolder.isFavorited == false  {
            folderStore.toggleFavoriteState(selectedFolder)
        }
         else if selectedFolder.isFavorited == true {
            folderStore.toggleFavoriteState(selectedFolder)
        }
    }
}

extension UIImage {
        func colored(in color: UIColor) -> UIImage {
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { context in
                color.set()
                self.withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
            }
        }
    }


