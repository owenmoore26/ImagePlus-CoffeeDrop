//
//  clickThroughViewController.swift
//  ImagePlus - Owen Moore
//
//  Created by Ashley Moore on 07/08/2018.
//  Copyright © 2018 Owen Moore. All rights reserved.
//

import UIKit
import PureLayout

class ClickThroughViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellID = "Cell"
    
    var tableView : UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        setupTableView()
        setupConstraints()
    }
    
    func setupTableView() {
        
        tableView.autoSetDimension(.height, toSize: 300)
        tableView.autoSetDimension(.width, toSize: view.frame.size.width)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempOpeningTimes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = tempOpeningTimes[indexPath.row]
        
        return cell
    }
}
