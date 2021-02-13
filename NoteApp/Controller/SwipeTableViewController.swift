//
//  SwipeTableViewController.swift
//  NoteApp
//
//  Created by Konstantin Dmitrievskiy on 13.02.2021.
//  Copyright © 2021 Konstantin Dmitrievskiy. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        


    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell, for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        
        return cell
        
    }

    func updateModel(at indexPayh: IndexPath) {
    }
    
    
}

extension SwipeTableViewController: SwipeTableViewCellDelegate {
    
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            
            guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                self.updateModel(at: indexPath)
              
//                let categoryFordeletion = self.categories[indexPath.row]
//
//                self.context.delete(categoryFordeletion)
//                self.categories.remove(at: indexPath.row)
//                self.saveData()
            }

            // customize the action appearance
            deleteAction.image = UIImage(named: "Trash Icon")

            return [deleteAction]
            
        }
    
}
