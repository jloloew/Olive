//
//  ViewController.swift
//  Olive
//
//  Created by Bri Chapman on 11/22/14.
//  Copyright (c) 2014 edu.illinois. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var oliveLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oliveLabel.font = UIFont (name: "KARMAFORM", size: 60)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

