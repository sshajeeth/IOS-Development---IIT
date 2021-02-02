//
//  ViewController.swift
//  Hello World
//
//  Created by Shajeeth Suwarnarajah on 2021-02-02.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var greet_label: UILabel!
    @IBOutlet weak var greet_btn: UIButton!
    @IBAction func greet(_ sender: UIButton) {
        self.greet_label.text = "Hello Shajeeth"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.greet_label.text = ""
    }


}

