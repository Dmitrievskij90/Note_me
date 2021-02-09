//
//  ViewController.swift
//  NoteApp
//
//  Created by Konstantin Dmitrievskiy on 09.02.2021.
//  Copyright © 2021 Konstantin Dmitrievskiy. All rights reserved.
//

import UIKit

class NoteViewController: UITableViewController {
    
    var notes = ["one", "two", "three"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        cell.textLabel?.text = notes[indexPath.row]
        
        return cell
        
    }
    
}
