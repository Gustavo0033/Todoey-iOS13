//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        loadItems(with: request)
        
        
    }
    
    
    
    //MARK: - TableView Datasource Methods
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        // um jeito diferente de usar se for verdadeiro/falso
        // se for verdadeira tera o checkmark, se não, sem checkmark
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Updating items
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //context.delete(itemArray[indexPath.row]) // removendo os dados do nosso context (permanent stores)
        //itemArray.remove(at: indexPath.row) // removendo o item atual do array
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new items
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new item on the Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //oq vai acontecer quando o user clicar para adicionar um item
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text! //esse title é do CoreData que criamos
            newItem.done = false //esse done é do CoreData que criamos e precisa receber uma valor para não dar erro no app
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true , completion: nil)
    }
    
    
    
    //MARK: - Creating items
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("error saving context")
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: - Reading items
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        
        
        do {
            itemArray = try context.fetch(request)
        } catch  {
            print("error fetching data from context")
        }
    }
}

//MARK: - SeachBar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Nessa consulta se torna "Para todos os itens no array que contem o title
        // que foi pesquisa na nossa searchBar.text
        request.predicate  = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
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


