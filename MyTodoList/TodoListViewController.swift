//
//  ViewController.swift
//  MyTodoList
//
//  Created by mac on 2020/8/7.
//  Copyright © 2020 WuHouxuan. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
//    let defaults = UserDefaults.standard
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
        print(dataFilePath as Any)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItem()
        
//        let newItem = Item()
//        newItem.title = "go home"
//        itemArray.append(newItem)
        
//        for index in 4...100 {
//            let newItem = Item()
//            newItem.title = "第\(index)件事"
//            itemArray.append(newItem)
//        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
//        cell.textLabel?.text = itemArray[indexPath.row]
        cell.textLabel?.text = itemArray[indexPath.row].title
        
//        if itemArray[indexPath.row].done == false {
//            cell.accessoryType = .none
//        } else {
//            cell.accessoryType = .checkmark
//        }
        let item = itemArray[indexPath.row]
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
//        tableView.beginUpdates()
//        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//        tableView.endUpdates()
        tableView.reloadData()
    }

        override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
            return "删除"
        }
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                //删除数据库中数据
                context.delete(itemArray[indexPath.row])
                itemArray.remove(at: indexPath.row)
                saveItems()
                // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "添加一条新的Todo项目", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "添加项目", style: .default) {
            (action) in
            print("成功添加：\(textField.text!)")
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
//            newItem.title = textField.text!
            self.itemArray.append(newItem)
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
            
            self.tableView.reloadData()
        }
        alert.addTextField {
            (alertTextfield) in
            alertTextfield.placeholder = "创建一个新项目..."
            textField = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
//        let encoder = PropertyListEncoder()
        do {
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: dataFilePath!)
            try context.save()
        } catch {
            print("编码错误：\(error)")
        }
    }
    
    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
//        if let data = try? Data(contentsOf: dataFilePath!) {
////            let decoder = PropertyListDecoder()
//            do {
////                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("解码错误：\(error)")
//            }
//        }
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("\(error)")
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[c] %@", searchBar.text!)
//        request.predicate = predicate
        request.predicate = NSPredicate(format: "title CONTAINS[C] %@", searchBar.text!)
//        let sortDesciptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDesciptor]
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItem(with: request)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            tableView.reloadData()
        }
    }
}
