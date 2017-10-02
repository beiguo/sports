//
//  NotesTableViewController.swift
//  myHealth
//
//  Created by shilei on 2017/9/12.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    var dataDic : NSDictionary!
    
    var dateArr = NSMutableArray()
    var valueArr = NSMutableArray()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let view = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = view
        
        getData()
        
    }
    
    func getData() {
        
        if (UserDefaults.standard.object(forKey: "Notes") != nil) {
            
            dataDic = NSDictionary(dictionary: UserDefaults.standard.object(forKey: "Notes") as! NSDictionary)
            
            
            for (key , value) in dataDic {
                
                dateArr.insert(key, at: 0)
                valueArr.insert(value, at: 0)
                
                
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dataDic != nil {
            return dataDic.count
        }
        
        return 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesTableViewCell
        
        if dateArr.count == 0 {
            
            return cell
        }
        
        if valueArr.count == 0 {
            
            return cell
        }
        
        cell.dateL.text = dateArr[indexPath.row] as? String
        
        let dic = valueArr[indexPath.row] as! NSDictionary
        
        if dic["steps"] == nil {
            
            return cell
            
        }
        cell.stepL.text = String(describing: dic["steps"]!)
        
        if dic["distance"] == nil {
            
            return cell
        }
        
        cell.distanceL.text = NumberFormatter.localizedString(from: dic["distance"]! as! NSNumber, number: .decimal)
        
        
        
        
        return cell
        
    }
    
    
    
    
}



