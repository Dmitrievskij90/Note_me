//
//  ViewController.swift
//  NoteApp
//
//  Created by Konstantin Dmitrievskiy on 09.02.2021.
//  Copyright © 2021 Konstantin Dmitrievskiy. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!

    var notesArray = [Notes]()
    
    let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Note.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //        print(dataFilePath)
        //
        //        let newNote = Notes()
        //        newNote.title = "hello"
        //        notesArray.append(newNote)
        
        //        if let notes = defaults.array(forKey: "notes") as? [Note] {
        //            notesArray = notes
        //        }
                loadNotes()
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
        //
        //        context.delete(notesArray[indexPath.row])
        //        notesArray.remove(at: indexPath.row)
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add note", message: "write your note below", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newNote = Notes(context: self.context)
            newNote.title = textField.text!
            newNote.done = false
            
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
        
        do {
            try context.save()
        } catch {
            print("Error\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadNotes(with request: NSFetchRequest<Notes> = Notes.fetchRequest()) {

//     let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        
        do{
            notesArray = try context.fetch(request)
        } catch {
            print("Error \(error)")
        }
        tableView.reloadData()
    }
    
}

extension NoteViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadNotes(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadNotes()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
