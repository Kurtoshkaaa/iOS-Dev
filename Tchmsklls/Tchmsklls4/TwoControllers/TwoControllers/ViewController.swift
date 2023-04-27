//
//  ViewController.swift
//  TwoControllers
//
//  Created by Alexey Kurto on 27.04.23.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var secondNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var sexTextField: UITextField!
    
    @IBOutlet weak var togglePresentScreen: UISwitch!

    /*
     */
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        guard let logicVC = storyboard?.instantiateViewController(withIdentifier: "logicViewController") as? logicViewController else {
            
            return
        }
        
        /*
         */
               
        logicVC.firstName = nameTextField.text ?? ""
        logicVC.secondName = secondNameTextField.text ?? ""
        logicVC.email = emailTextField.text ?? ""
        logicVC.phoneNumber = phoneNumberTextField.text ?? ""
        logicVC.sex = sexTextField.text ?? ""
        
        /*
         */
        
        if togglePresentScreen.isOn {
            navigationController?.pushViewController(logicVC, animated: true)
        } else {
            present(logicVC, animated: true, completion: nil)
        }
    }
}

