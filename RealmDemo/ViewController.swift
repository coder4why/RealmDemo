//
//  ViewController.swift
//  RealmDemo
//
//  Created by qwer on 2018/3/13.
//  Copyright © 2018年 qwer. All rights reserved.
//
import Realm.RLMRealm
import UIKit

class ViewController: UIViewController {

    //当前页面的数据源：
    private var tasks : Array<Task>!
    
    private var taskListA = TaskList()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tasks = Array<Task>()
        
        taskListA = TaskList()
        taskListA.name = "Wishlist"
       
        /**
         创建 Realm 对象的三种途径：
         wish1 的实例化方式：简单的实例化 Realm 类，然后设置属性。
         wish2 的实例化方式：传入一个字典，字典中的 key 为属性名，值为要设置的值。
         wish3 的实例化方式：使用数组传入的方式。数组中值的顺序需要和模型类中的声明顺序一致。
         **/
        let wish1 = Task()
        wish1.name = "iPhone6s"
        wish1.notes = "64 GB, Gold"
        
        let wish2 = Task(value: ["name": "Game Console", "notes": "Playstation 4, 1 TB"])
        let wish3 = Task(value: ["Car", NSDate(), "Auto R8", false])
        
        taskListA.tasks.append(wish1)
        taskListA.tasks.append(wish2)
        taskListA.tasks.append(wish3)
        
        taskListA.name = "Taitanic"
        // 在 Realm 中还可以是使用嵌套的方式来创建对象，新增字段容易崩溃
        //self.taskListB = TaskList(value: ["MoviesList", NSDate(), [["The Martian", NSDate(), "Apple 2016", false], ["The Maze Runner", NSDate(), "MacBook Pro 2018", true]]])
        
        //写入Realm的数据：写入TaskList类型；
        try? AppDelegate.uiRealm?.write({

            AppDelegate.uiRealm?.add(taskListA)

        })
        
        self.readDatas()
        
    }
    
    //读取Realm的数据：读取TaskList类型；
    private func readDatas(){
        
        if self.tasks.count>0 {
            self.tasks.removeAll()
        }
        
        let taskss = AppDelegate.uiRealm?.objects(TaskList.self)
        taskss?.forEach({ (task) in
            
            task.tasks.forEach({ (kk) in
                self.tasks.append(kk)
            })
           
        })
        
        self.tableView.reloadData()
        
        self.animatedTable()
        
    }
    
    //cell显示动画；
    private func animatedTable(){
        
        let cells = tableView.visibleCells
        let tabHeight = tableView.bounds.size.height
        cells.forEach { (ce) in
            
            ce.transform = CGAffineTransform.init(translationX: 0, y: tabHeight)
            
        }
        
        var index = 0
        cells.forEach { (ce) in
            
            UIView.animate(withDuration: 1, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                
                ce.transform = CGAffineTransform.init(translationX: 0, y: 0)
                
            }, completion: nil)
         
            index += 1
            
        }
    }
    
    @IBAction func addTask(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "Add an Realm Datas", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter notes"
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (alertA) in }
        let addAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (alertA) in
            
            let taskList = TaskList()
            let task = Task()
            task.name = alert.textFields?.first?.text ?? ""
            task.notes = alert.textFields?.last?.text ?? ""
            taskList.name = task.name+" datas"
            taskList.tasks.append(task)
            //调用Realm的写方法：
            try? AppDelegate.uiRealm?.write({
                AppDelegate.uiRealm?.add(taskList)
            })
            
            self.readDatas()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //显示最新的数据：
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.readDatas()
        
    }

}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tasks.count
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellid = "cellid"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        
        cell?.textLabel?.text = self.tasks[indexPath.row].name
        cell?.detailTextLabel?.text = self.tasks[indexPath.row].notes
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DescriptionVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}

