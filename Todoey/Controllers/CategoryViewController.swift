//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mert İdacı on 5.08.2018.
//  Copyright © 2018 navyblue. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    //Realm Initialize
    let realm = try! Realm()
    
    //TabeView Items
    var categoryArray = [Category]()
    
    //Context for Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load_Realm()

    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFld = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
   
            //REALM USE:
            let newCategory = Category()//-> Realm
            newCategory.name = textFld.text!
            self.categoryArray.append(newCategory)
            self.save_Realm(category: newCategory)
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create New Category"
            textFld = textField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //TABLE Functions************
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItemCell", for: indexPath)
        
        let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        //Goto Items Table
        performSegue(withIdentifier: "goToItems", sender: self)
        
        //Effect
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destination.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    //**********************************
    
    //REALM SAVE
    func save_Realm(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving with Core Data: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //REALM LOAD
//    func load_Realm(with request : NSFetchRequest<Category> = Category.fetchRequest()){
//
//        do{
//            categoryArray = try context.fetch(request)
//        }catch{
//            print("Error loading Items with Core Data: \(error)")
//        }
//        self.tableView.reloadData()
//    }
    
}

