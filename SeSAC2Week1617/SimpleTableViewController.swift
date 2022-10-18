//
//  ViewController.swift
//  SeSAC2Week1617
//
//  Created by 강민혜 on 10/18/22.
//

import UIKit

class SimpleTableViewController: UITableViewController {
    
    let list = ["슈비버거", "프랭크", "자갈치", "고래밥"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "")!
//        cell.textLabel?.text = list[indexPath.row]
        
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = list[indexPath.row] // textLabel
        content.secondaryText = "안녕하세요" // detailTextLabel
        
        cell.contentConfiguration = content
        return cell
    }

}

