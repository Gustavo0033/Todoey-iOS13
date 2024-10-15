//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{
    
    
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
    }
    
    
    
    //MARK: - TableView Datasource Methods
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            // um jeito diferente de usar se for verdadeiro/falso
            // se for verdadeira tera o checkmark, se não, sem checkmark
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No items added yet"
        }
        return cell
        
        
    }
    
    //MARK: - Updating items
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //updating Realm Database
        if let item = toDoItems?[indexPath.row]{
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch  {
                print("Error while saving done status \(error)")
            }
            
        }
        
        tableView.reloadData()
    }
    
    //MARK: - add new items
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()


        let alert = UIAlertController(title: "Add a new item on the Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //oq vai acontecer quando o user clicar para adicionar um item
            
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dataCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Erro saving new items\(error)")
                }
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true , completion: nil)
    }
    
    
    /*
     //MARK: - Creating items
     func saveItems(){
     do{
     try realm.write {
     realm.add(item)
     }
     }catch{
     print("error saving context")
     }
     self.tableView.reloadData()
     }
     */
    
    
    //MARK: - Reading items
    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}


//MARK: - SeachBar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dataCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {  //quando eu clicar no pequeno X do searcBar e ele ficar sem nenhum texto dentro
            loadItems()
            
            
            //assim que eu apertei no x e o teclado ficar sem nenhum texto, o teclado irá sumir
            // e veremos todos os items novamente
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }
        }
    }
    
    
}
