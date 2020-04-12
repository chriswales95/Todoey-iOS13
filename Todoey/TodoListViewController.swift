//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    var items = [ToDoItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            items = try context.fetch(.init(entityName: "ToDoItem")) as [ToDoItem]
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveItems() {
        do {
            try context.save()
            self.tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addButtonClick(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New todo", message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Add", style: .default) { (alert) in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newItem = ToDoItem(context: context)
            newItem.title = textField.text
            self.items.append(newItem)
            self.saveItems()
        }
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alert.addAction(ok)
        alert.addTextField { (localTextField) in
            textField = localTextField
            localTextField.placeholder = "What do you need to do?"
        }
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cellData = items[indexPath.row]
        
        cell.textLabel?.text = cellData.title
        cell.accessoryType = cellData.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        items[indexPath.row].done = !items[indexPath.row].done
        
        self.tableView.reloadData()
        self.saveItems()
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "DEL"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        tableView.beginUpdates()
        context.delete(items[indexPath.row])
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        saveItems()
    }
    
}

