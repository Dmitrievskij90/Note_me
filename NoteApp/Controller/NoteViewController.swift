//
//  ViewController.swift
//  NoteApp
//
//  Created by Konstantin Dmitrievskiy on 09.02.2021.
//  Copyright © 2021 Konstantin Dmitrievskiy. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private  var notesArray = [Notes]()
    
//    let defaults = UserDefaults.standard
    
    private  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: Category? {
        didSet {
            loadNotes()
        }
    }
    
//     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Note.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //        print(dataFilePath)
        //
        //        let newNote = Notes()
        //        newNote.title = "hello"
        //        notesArray.append(newNote)
        
        //        if let notes = defaults.array(forKey: "notes") as? [Note] {
        //            notesArray = notes
        //        }
//                loadNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
           title = selectedCategory?.name
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
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
    
    //MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add note", message: "write your note below", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newNote = Notes(context: self.context)
            newNote.title = textField.text!
            newNote.done = false
            
            newNote.parentCategory = self.selectedCategory
            
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
    
    //MARK: - Data manipulating methods
    
    override func updateModel(at indexPath: IndexPath) {
        
        let categoryFordeletion = self.notesArray[indexPath.row]
        
        context.delete(categoryFordeletion)
        notesArray.remove(at: indexPath.row)
        saveData()
    }
    
   private func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Error\(error)")
        }
        
        self.tableView.reloadData()
    }
    
  private  func loadNotes(with request: NSFetchRequest<Notes> = Notes.fetchRequest(), predicate: NSPredicate? = nil) {

//     let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do{
            notesArray = try context.fetch(request)
        } catch {
            print("Error \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - SearcBardelegate methods

extension NoteViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadNotes(with: request, predicate: predicate)
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
