//
//  ViewController.swift
//  NoteApp
//
//  Created by Konstantin Dmitrievskiy on 09.02.2021.
//  Copyright © 2021 Konstantin Dmitrievskiy. All rights reserved.
//

import UIKit

class NoteViewController: UITableViewController {
    
    var notesArray = [Note]()
    
    let defaults = UserDefaults.standard
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Note.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        let newNote = Note()
        newNote.title = "hello"
        notesArray.append(newNote)
        
//        if let notes = defaults.array(forKey: "notes") as? [Note] {
//            notesArray = notes
//        }

    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        cell.textLabel?.text = notesArray[indexPath.row].title
        
        let note = notesArray[indexPath.row].done
        
        cell.accessoryType = note ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        notesArray[indexPath.row].done = !notesArray[indexPath.row].done
        
        saveData()
        
//        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add note", message: "write your note below", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newNote = Note()
            newNote.title = textField.text!
            
            self.notesArray.append(newNote)
            
//            self.defaults.set(self.notesArray, forKey: "notes")
            
            self.saveData()
            
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "My note"
            
            textField = alertTextField
        }
        
    }
    
    func saveData() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.notesArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
}

