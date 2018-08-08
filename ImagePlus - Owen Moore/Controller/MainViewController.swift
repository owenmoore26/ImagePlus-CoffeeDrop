//
//  MainViewController.swift
//  ImagePlus - Owen Moore
//
//  Created by Ashley Moore on 06/08/2018.
//  Copyright © 2018 Owen Moore. All rights reserved.
//

import UIKit

class mainViewController: UIViewController {
    
    override func viewDidLoad() {
        
        view.addSubview(view)
    }
    
    lazy var textField: UITextField! = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        view.textAlignment = .center
        
        return view
    }()
}
