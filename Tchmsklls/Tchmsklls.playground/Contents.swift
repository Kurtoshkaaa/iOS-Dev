// Aleksey Kurto 09.04.2023

import UIKit

/*
 Classes: My family
 */

class Family {
    private var members = 0
    private var name: String
    private var secondName: String
    private var age: Int
    private var gender: String
    private var weight: Double
    private var height: Double
    
    /*
     */
    
    init(members: Int, name: String, secondName: String, age: Int, gender: String, weight: Double, height: Double) {
        self.members = members
        self.name = name
        self.secondName = secondName
        self.age = age
        self.gender = gender
        self.weight = weight
        self.height = height
    }
    
    func addMember() {
        members += 1
        print("Congratulations! You have a new member of the family \(members)")
    }
}
