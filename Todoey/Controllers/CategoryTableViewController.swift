//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Gustavo Mendonca on 03/10/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80
        
        //let request: NSFetchRequest<Category> = Category.fetchRequest()
        //loadCategories(with: request)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else{
            fatalError("Navigation controller does not exist")
        }
        
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { action in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            self.saveCategories(category: newCategory)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true , completion: nil)
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // se categories for nil, retornará uma linha
        // caso NÃO seja nil retornará o a quantidade de items
        categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            //se for nil, retornará o que está entre aspas
            // caso seja verdadeiro, retornará os items
            cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"
            cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "#1D98F6")
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
        }
        


        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
    func saveCategories(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch  {
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath){
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do {
                try self.realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch  {
                print("Error while trying to delete. \(error)")
            }
        }
        
    }
}


