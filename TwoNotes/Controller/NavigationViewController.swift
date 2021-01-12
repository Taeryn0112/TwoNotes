//
//  NavigationViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 1/11/21.
//

import UIKit

class NavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startObserving(&UserInterfaceStyleManager.shared)
    }
}
