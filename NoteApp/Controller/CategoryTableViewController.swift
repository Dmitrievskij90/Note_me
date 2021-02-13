//
//  CategoryTableViewController.swift
//  NoteApp
//
//  Created by Konstantin Dmitrievskiy on 11.02.2021.
//  Copyright © 2021 Konstantin Dmitrievskiy. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: SwipeTableViewController {
    
    private var categories = [Category]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadCategories()
        
    }
    
    //MARK: - TableView Data sourse methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCell, for: indexPath) as! SwipeTableViewCell
//
//        cell.delegate = self
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newNote = Category(context: self.context)
            newNote.name = textField.text!
            
            self.categories.append(newNote)
            
            self.saveData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "My note"
            
            textField = alertTextField
        }
    }
    
    //MARK: - Data manipulation methods
    
    override func updateModel(at indexPath: IndexPath) {
        
        let categoryFordeletion = self.categories[indexPath.row]

            context.delete(categoryFordeletion)
            categories.remove(at: indexPath.row)
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
    
    private func loadCategories() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Table View Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: K.notesSegue, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! NoteViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    
}

//extension CategoryTableViewController : SwipeTableViewCellDelegate {
//
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//
//            let categoryFordeletion = self.categories[indexPath.row]
//
//            self.context.delete(categoryFordeletion)
//            self.categories.remove(at: indexPath.row)
//            self.saveData()
//
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "Trash Icon")
//
//        return [deleteAction]
//
//    }
//
//
//
//}
