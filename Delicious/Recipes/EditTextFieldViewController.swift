//
//  EditInstructionViewController.swift
//  Delicious
//
//  Created by Rebecca Cheung on 29/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class EditTextFieldViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var labelTitle: String?
    var enteredText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = labelTitle ?? ""
        textField.text = enteredText ?? ""
    }
}
