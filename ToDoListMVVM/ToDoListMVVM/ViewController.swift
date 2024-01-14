//
//  ViewController.swift
//  ToDoListMVVM
//
//  Created by Нурсат Шохатбек on 14.01.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var viewModel: ContactViewModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = ContactViewModal { [unowned self] (state) in
            switch state.editingStyle {
                
            case .addContact(_):
                textField.text = ""
                break
            case .deleteContact(_):
                break
            case .toggleContact(_):
                break
            case .loadContact(_):
                break
            case .none:
                break
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.loadContact()
    }

    @IBAction func addTask(_ sender: Any) {
        
        viewModel?.addNewContact(name: textField.text!)
    }
    
}

