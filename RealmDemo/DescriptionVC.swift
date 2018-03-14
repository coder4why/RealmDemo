//
//  DescriptionVC.swift
//  RealmDemo
//
//  Created by qwer on 2018/3/14.
//  Copyright © 2018年 qwer. All rights reserved.
//
import RealmSwift.Swift
import UIKit

class DescriptionVC: UITableViewController {

    private var taskLists:Array<TaskList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.taskLists = Array<TaskList>()
        self.title = "Update And Delete"
        //Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        //下面一行显示一个编辑在这个视图控制器的导航栏按钮。
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.editButtonItem.action = #selector(self.clickEdit)
        
        self.readDatas()
       
    }
    
    @objc private func clickEdit(){
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.taskLists.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskLists[section].tasks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellid = "cellid"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        cell?.textLabel?.text = self.taskLists[indexPath.section].tasks[indexPath.row].name
        cell?.detailTextLabel?.text = self.taskLists[indexPath.section].tasks[indexPath.row].notes
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            try? AppDelegate.uiRealm?.write({ () -> Void in
                //这个是删除一个section的数据；
//                AppDelegate.uiRealm?.delete(self.taskLists[indexPath.section])
                self.taskLists[indexPath.section].tasks.remove(at: indexPath.row)
                //删除所有数据；
//                AppDelegate.uiRealm?.deleteAll()
            })
            
            self.readDatas()
        }
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            // 这里是编辑
            let listToBeUpdated = self.taskLists[indexPath.section].tasks[indexPath.row]
            self.displayAlertToAddTaskList(listToBeUpdated,indexPath.section,indexPath.row)
            
        }
        return [deleteAction, editAction]
        
    }

    //读取Realm的数据：读取TaskList类型；
    private func readDatas(){
        
        if self.taskLists.count > 0{
            self.taskLists.removeAll()
        }
        
        let results = AppDelegate.uiRealm?.objects(TaskList.self)
        try? AppDelegate.uiRealm?.write {
            //可以在无需遍历每个对象的情况下，批量更新对象数据的属性值
            results?.setValue(true, forKeyPath: "isCompleted")
            
        }
        
        results?.forEach({ (taskList) in
            self.taskLists.append(taskList)
            print(taskList.isCompleted)
        })
        
        self.tableView.reloadData()
        
    }
    
    //显示alert更新数据；
    private func displayAlertToAddTaskList(_ tasklist:Task, _ section:Int,_ row:Int){
        
        let alert = UIAlertController.init(title: "Update an Realm Datas", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = tasklist.name
        }
        alert.addTextField { (textField) in
            textField.placeholder = tasklist.notes
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (alertA) in }
        let addAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (alertA) in
            
            //调用Realm的写方法：
            try? AppDelegate.uiRealm?.write({
                let task = self.taskLists[section].tasks[row]
                task.name = alert.textFields?.first?.text ?? ""
                task.notes = alert.textFields?.last?.text ?? ""
                
            })
            
            self.readDatas()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
