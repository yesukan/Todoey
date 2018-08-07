//
//  ViewController.swift
//  Todoey
//
//  Created by Yesukan Kozok on 2.08.2018.
//  Copyright © 2018 yesukan. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{

    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            //loadItems()
            }
    }

   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        tableView.separatorStyle = .none
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        
        guard let colorHex = selectedCategory?.color else { fatalError() }
            
            title = selectedCategory?.name
        
        updateNavBar(withHexCode: colorHex)
            
            
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    
    //MARK: Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("controller does not exist")}
        
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }
    
    
    //MARK - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
                 cell.backgroundColor = color
                
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
//            print("version 1: \(CGFloat(indexPath.row/todoItems!.count))")
//            print("version 1: \(CGFloat(indexPath.row)/CGFloat(todoItems!.count)))")
            
            
            //Ternary operator -> value = condition ? valiftrue :valiffalse
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item Added"
        }
        return cell
    }
    
    //MARK - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    //DELETING ITEM
                    //realm.delete(item)
                }
            } catch {
                print("Error changing done status \(error)")
            }
        }
        
        //print(itemArray[indexPath.row])
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
//        todoItem[indexPath.row].done = !todoItem[indexPath.row].done
//
//        saveItems()
    
        //the cell you touch becomes grey and white again
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    //MARK - Add new items

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        
                    }
                }catch {
                        print("Error saving new item, \(error)")
                }
            }
            
            self.tableView.reloadData()
        
        }
        
       
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
    }
    
   
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                realm.delete(item)
            }
            } catch {
                print("Error deleting the item")
            }
        }
    }
    

}


//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            //if nothing writes at the search bar just loadItems
            loadItems()

            //to take it not to background but foreground
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }


        }
    }
}
