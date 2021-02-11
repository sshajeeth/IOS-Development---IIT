//
//  ViewController.swift
//  Utility Converter
//
//  Created by Shajeeth Suwarnarajah on 2021-02-10.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        CustomKeyboardController.activeTextField = textField
    }


}

