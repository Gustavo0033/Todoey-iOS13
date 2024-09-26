//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var item = ["Find Mike", "Buy eggs", "But apples"]

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
     
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = item[indexPath.row]
        
        return cell
    }
    
    //MARK: - tableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(item[indexPath.row])

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{ //checkMark de quando clicarmos em um item da tableView
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new items
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new item on the Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //oq vai acontecer quando o user clicar para adicionar um item
            
            //vai adicionar o item que foi digitado pelo usuario na nossa lista
            self.addItemOnList(textField.text!)
            self.tableView.reloadData()
            
            
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true , completion: nil)
    }
    
    //MARK: - funcão que adiciona o item que o usuario escreveu na nossa lista
    func addItemOnList(_ newItem: String){
        item.append(newItem)
        self.tableView.reloadData()
        
    }
}

