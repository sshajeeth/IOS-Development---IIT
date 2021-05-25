//
//  NotesPopUpController.swift
//  ExpensesManager
//
//  Created by Shajeeth Suwarnarajah on 2021-05-21.
//  Copyright © 2021 Philip Trwoga. All rights reserved.
//

import Foundation
import UIKit

class NotesPopoverController: UIViewController {
    
    @IBOutlet weak var notesTextView: UITextView!
    
    var notes: String? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func configureView() {
        if let notes = notes {
            if let notesTextView = notesTextView {
                notesTextView.text = notes
            }
        }
    }
}
