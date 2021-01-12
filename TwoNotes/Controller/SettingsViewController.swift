//
//  SettingsViewController.swift
//  TwoNotes
//
//  Created by Terry Lee on 1/11/21.
//

import UIKit
import RealmSwift

class SettingsViewController: UITableViewController {
    
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkModeSwitch.isOn = UserInterfaceStyleManager.shared.currentStyle == .dark
        
        startObserving(&UserInterfaceStyleManager.shared)
        
    }
    
    
    @IBAction func darkModeSwitchValueChanged(_ sender: UISwitch) {
        
        let darkModeOn = sender.isOn
        
        UserDefaults.standard.set(darkModeOn, forKey: UserInterfaceStyleManager.userInterfaceStyleDarkModeOn)
        
        UserInterfaceStyleManager.shared.updateUserInterfaceStyle(darkModeOn)
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "settingCell")
        cell.textLabel?.text = "Dark Mode"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
