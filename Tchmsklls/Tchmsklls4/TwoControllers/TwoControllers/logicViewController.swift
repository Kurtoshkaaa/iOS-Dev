//
//  logicViewController.swift
//  TwoControllers
//
//  Created by Alexey Kurto on 27.04.23.
//

import UIKit

class logicViewController: UIViewController {

    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var secondNameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var sexLabel: UILabel!
    
    /*
     */
    
    var firstName = ""
    var secondName = ""
    var email = ""
    var phoneNumber = ""
    var sex = ""
    
    /*
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peopleShow()

    }
    
    /*
     */
    
    func peopleShow() {
        firstNameLabel.text = firstName
        secondNameLabel.text = secondName
        emailLabel.text = email
        phoneNumberLabel.text = phoneNumber
        sexLabel.text = sex
    }
}
