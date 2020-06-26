//
//  IngredientsTableViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 24/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class IngredientsTableViewController: UITableViewController {
    
    var titleDataList: [String] = []
    var detailDataList: [String] = []
    var numberOfRecipes: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleDataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IngredientsTableViewCell
        let title = titleDataList[indexPath.row]
        cell.titleLabel.text = title
        if detailDataList.count > 0 {
            let detail = detailDataList[indexPath.row]
            cell.detailLabel.text = detail
        } else {
            cell.detailLabel.text = ""
        }
        return cell
    }
}

