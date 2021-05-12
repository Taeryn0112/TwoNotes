//
//  NotesViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 12/2/20.
//

import UIKit
import RealmSwift


public class NoteDetailViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var notesDateLabel: UILabel!
    var viewModel: NoteDetailViewModel!
    @IBOutlet weak var noteDetailToolBar: UIToolbar!
    @IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!
    var image: UIImage?
    var imagePicker = UIImagePickerController()
    
    enum ImageSource {
            case photoLibrary
            case camera
        }
    
// MARK: View
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear(noteText: noteTextView.text, titleText: titleTextField.text ?? "")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        cameraBarButtonItem.imageInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0, right: 560)
        
        startObserving(&UserInterfaceStyleManager.shared)
        noteTextView.delegate = self
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        noteTextView.text = viewModel.noteText
        titleTextField.text = viewModel.titleText
        notesDateLabel.text = viewModel.dateText 
    }

// MARK: Delegates
    public func textViewDidChange(_ textView: UITextView) {
        let today = Date()
        notesDateLabel.text = DateUtils.shared.string(from: today)
        viewModel.textDidChange()
    }
    
    @objc public func textFieldDidChange(_ textField: UITextField) {
        let today = Date()
        notesDateLabel.text = DateUtils.shared.string(from: today)
        viewModel.textDidChange()
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let attachment = NSTextAttachment()
        
        self.image = image
        print("\(self.image) image stored")
        attachment.image = self.image
        
        let iconString = NSAttributedString(attachment: attachment)
        let firstString = NSMutableAttributedString(string: " ")

        firstString.append(iconString)
        
        self.noteTextView.attributedText = firstString
        
        dismiss(animated: true, completion: nil)
    }
    
// MARK: Methods
    @objc public func doneTapped() {
        print("done")
        noteTextView.resignFirstResponder()
        titleTextField.resignFirstResponder()
        }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.sourceType = .camera
//
//        } else {
//            imagePicker.sourceType = .photoLibrary
//        }
//
//        imagePicker.delegate = self
//
//        present(imagePicker, animated: true, completion: nil)
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    func selectImageFrom(_ source: ImageSource) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}


