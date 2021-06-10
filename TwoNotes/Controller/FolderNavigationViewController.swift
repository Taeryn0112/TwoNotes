//
//  FolderNavigationViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 6/8/21.
//

import UIKit

class FolderNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startObserving(&UserInterfaceStyleManager.shared)
    }
}
