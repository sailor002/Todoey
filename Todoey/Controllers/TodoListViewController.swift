//
//  ViewController.swift
//  Todoey
//
//  Created by Mert İdacı on 4.08.2018.
//  Copyright © 2018 navyblue. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //TabeView Items
    var itemArray = [Item]()
    
    //Selected Category
    var selectedCategory : Category?{
        didSet{
            
            print("Category Name: \(selectedCategory!.name!)")
            
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            
            request.predicate = predicate
            
            loadItems_Core(with: request)
        }
    }
    
    //File Path For Encoder
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //Context for Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //DEFAULTS DECLARATION:
//    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //DEFAULTS READ:
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
        
        //ENCODER USE:
//      loadItems_Encoder()
        
    
        
    }

    //MARK - Table View Data Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    
    //MARK - TableView Item Click Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //CORE UPDATE:
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems_Core()
        
        //CORE DELETE (Sequence is IMPORTANT!):
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        saveItems_Core()
        
        //Effect
        tableView.deselectRow(at: indexPath, animated: true)
        
        //saveItems_Encoder()
    }
    
    //MARK - Add Item Button
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textFld = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //ENCODER USE:
//            let newItem = Item_Coder() //-> Codable Object
//            newItem.title = textFld.text!
//            self.itemArray.append(newItem)
//            self.saveItems_Encoder()
            
            
            //DEFAULTS WRITE:
//          self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
            //CORE USE:
            let newItem = Item(context: self.context)//-> Database Object
            newItem.title = textFld.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems_Core()
            
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create New Item"
            textFld = textField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //ENCODER WRITE:
//    func saveItems_Encoder(){
//
//        let encoder = PropertyListEncoder()
//        do{
//
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.dataFilePath!)
//        }catch{
//            print("Error encoidng data: \(error)")
//        }
//
//        self.tableView.reloadData()
//    }
    
    //ENCODER READ:
//    func loadItems_Encoder(){
//
//        if let data = try? Data(contentsOf: dataFilePath!){
//
//            let decoder = PropertyListDecoder()
//
//            do{
//                itemArray = try decoder.decode([Item_Coder].self, from: data)
//            }catch{
//                print("Error decoding: \(error)")
//            }
//
//        }
//    }
    
    //CORE SAVE
    func saveItems_Core(){
        do{
            try context.save()
        }catch{
            print("Error saving with Core Data: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //CORE LOAD
    func loadItems_Core(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error loading Items with Core Data: \(error)")
        }
        self.tableView.reloadData()
    }
    
    

}

extension TodoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Search and category based request
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, categoryPredicate])
        request.predicate = compoundPredicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]        
        
        //Check If Textfield is empty
        if searchBar.text?.count == 0{
            request.predicate = categoryPredicate
            loadItems_Core(with: request)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }else{
            loadItems_Core(with: request)
        }
    }
    
}

