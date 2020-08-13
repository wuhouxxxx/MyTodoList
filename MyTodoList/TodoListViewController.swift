//
//  ViewController.swift
//  MyTodoList
//
//  Created by mac on 2020/8/7.
//  Copyright © 2020 WuHouxuan. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{
    
//    let defaults = UserDefaults.standard
    var todoItems: Results<Item>?
    let realm = try! Realm()
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            todoItems = items
//        print(dataFilePath as Any)
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        loadItems()
        
//        let newItem = Item()
//        newItem.title = "go home"
//        todoItems.append(newItem)
        
//        for index in 4...100 {
//            let newItem = Item()
//            newItem.title = "第\(index)件事"
//            todoItems.append(newItem)
//        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
//        cell.textLabel?.text = todoItems[indexPath.row]

        
//        if todoItems[indexPath.row].done == false {
//            cell.accessoryType = .none
//        } else {
//            cell.accessoryType = .checkmark
//        }
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = todoItems?[indexPath.row].title
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "没有事项"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }

//        todoItems?[indexPath.row].done = !todoItems?[indexPath.row].done
//        saveItems()
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print(error)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
//        tableView.beginUpdates()
//        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
//        tableView.endUpdates()
        tableView.reloadData()
    }

//        override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//            return "删除"
//        }
//        // Override to support editing the table view.
//        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//            if editingStyle == .delete {
//                //删除数据库中数据
//                context.delete(todoItems?[indexPath.row])
//                todoItems?.remove(at: indexPath.row)
//                saveItems()
//                // Delete the row from the data source
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            } else if editingStyle == .insert {
//                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//            }
//        }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "添加一条新的Todo项目", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "添加项目", style: .default) {
            (action) in
//            print("成功添加：\(textField.text!)")
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        self.realm.add(newItem)
                    }
                } catch {
                    print(error)
                }
            }
            
            
//            newItem.parentCategory =  self.selectedCategory
//            newItem.title = textField.text!
//            self.todoItems?.append(newItem)
//            self.defaults.set(self.todoItems, forKey: "TodoListArray")
            
//            self.saveItems()
            
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
    
//    func saveItems(item: Item) {
////        let encoder = PropertyListEncoder()
//        do {
////            let data = try encoder.encode(self.todoItems)
////            try data.write(to: dataFilePath!)
//            try realm.write {
//                realm.add(item)
//            }
//            print("saveitem, todoItems?.count: \(todoItems?.count)")
//        } catch {
//            print("编码错误：\(error)")
//        }
//    }
    
    func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                todoItems = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("解码错误：\(error)")
//            }
//        }
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let addtionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//        do {
//            todoItems = try context.fetch(request)
//            print("loaditem, todoItems.count: \(todoItems.count)")
//        } catch {
//            print("\(error)")
//        }
//        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        todoItems = realm.objects(Item.self)
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS[C] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        todoItems = todoItems?.filter("title CONTAINS[c] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            tableView.reloadData()
        }
    }
}
