//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Yesukan Kozok on 5.08.2018.
//  Copyright © 2018 yesukan. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        
    }
    

    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let category = categoryArray?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        }
        
        

        return cell
    }
    

    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    //MARK: - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //let newCategory = Category(context: self.context)
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            //hexValue yazınca string oldu
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category : Category) {
        
        do {
            
            // try context.save()
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
    }
  
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//        
        tableView.reloadData()
    }

    
    override func updateModel(at indexPath: IndexPath) {
                    if let categoryForDeletion = self.categoryArray?[indexPath.row] {
        
                        do {
                            try self.realm.write {
                                self.realm.delete(categoryForDeletion)
                            }
                        } catch {
                            print("Error deleting category \(error)")
        
                        }

                    }

    }
}



