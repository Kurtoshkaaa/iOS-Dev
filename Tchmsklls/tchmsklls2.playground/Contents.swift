// Aleksey Kurto 09.04.2023

import UIKit

/*
 MARK: - separator
 */

func separator() {
    print("_____________________________")
}

/*
 MARK: - class "Families"
 */

class Families {
    private var members = 0
    private var name = ""
    private var secondName = ""
    private var age = 0
    private var gender = ""
    private var weight = 0.0
    private var height = 0.0
    
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
    
    init() {
        
    }
    
    /*
     */
    
    func addMember() {
        members += 1
        print("Congratulations! You have a new \(members) member of the family")
    }
    
    /*
     */
    
    func reSecondName(secondName: String) -> String {
        self.secondName
        print("Second name was change to:")
        
        /*
         */
        
        separator
        return secondName
        
        /*
         */
    }
    
    /*
     */
    
    func familyExpansion (members: Int) {
        if members == 0 {
            print("Think about family")
        } else if
            members == 1 {
            print("Soon we will have to think about children")
        } else {
            self.members + members >= 2
            print("You guys are great")
        }
        separator()
    }
    
    /*
     */
    
    func fullInfo() {
        print("Members: \(self.members)")
        print("Name: \(self.name)")
        print("Second name: \(self.secondName)")
        print("Age: \(self.age)")
        print("Gender level: \(self.gender)")
        print("Weight level: \(self.weight)")
        print("Height level: \(self.height)")
        
        /*
         */
        
        separator()
    }
}

/*
 */

var firstFamily = Families(
    members: 0,
    name: "Alex",
    secondName: "Popov",
    age: 20,
    gender: "Male",
    weight: 65.5,
    height: 180.2
)

var secondFamily = Families(
    members: 1,
    name: "Roma",
    secondName: "Bulka",
    age: 34,
    gender: "Male",
    weight: 95.0,
    height: 177.7
)

var threeFamily = Families(
    members: 2,
    name: "Lesha",
    secondName: "Kurto",
    age: 30,
    gender: "Male",
    weight: 75.5,
    height: 164.5
)

/*
 */


firstFamily.addMember()
firstFamily.addMember()
separator()

/*
 */

print(secondFamily.reSecondName(secondName: "Hlebyshkin"))
separator()

/*
 */

threeFamily.familyExpansion(members: 2)

/*
 */

firstFamily.fullInfo()
secondFamily.fullInfo()
threeFamily.fullInfo()

/*
 MARK: - class "Animal"
 */

class Animal {
    private var className: String
    private var type: String
    private var status: String
    private var strenght: Double
    private var stamina: Double
    private var speed: Double
    private var health: Double
    
    /*
     */
    
    init(className: String, type: String, status: String, strenght: Double, stamina: Double, speed: Double, health: Double) {
        self.className = className
        self.type = type
        self.status = status
        self.strenght = strenght
        self.stamina = stamina
        self.speed = speed
        self.health = health
    }
    
    /*
     */
    
    init() {
        self.className = ""
        self.type = ""
        self.status = ""
        self.strenght = 86.0
        self.stamina = 65.9
        self.speed = 99
        self.health = 1.0
    }
    
    /*
     */
    
    func hunt(huntStats: Int) -> Int {
        
        let summParam = strenght + stamina + speed
        
        /*
         */
        
        if summParam - 15 >= 200 {
            self.health = 1
            print("Healthy animal")
        } else if
            summParam - 101 >= 200 {
            self.health -= 0.1
            print("Maybe healthy animal: health = \(self.health)")
        } else {
            print("Not a healthy animal")
        }
        
        /*
         */
        
        separator()
        return huntStats
    }
    
    /*
     */
    
    func experience() {
        if self.type == "Zoo" {
            print("Bad life experience")
        } else {
            print("Perfect life experience")
        }
        
        /*
         */
        
        separator()
    }
    
    /*
     */
    
    func info() {
        print("Class name: \(className)")
        print("Type: \(type)")
        print("Status: \(status)")
        print("Strenght: \(strenght)")
        print("Stamina: \(stamina)")
        print("Speed: \(speed)")
        print("Health: \(health)")
        
        /*
         */
        
        separator()
        
    }
    
    /*
     */
    
}

var leopard = Animal(
    className: "Cats",
    type: "Wild nature",
    status: "Leopard",
    strenght: 65.5,
    stamina: 77.6,
    speed: 98.8,
    health: 0.9
)

var tiger = Animal(
    className: "Cats",
    type: "Zoo",
    status: "Tiger",
    strenght: 99.3,
    stamina: 78.6,
    speed: 55.4,
    health: 1
)

var whiteTiger = Animal(
    className: "Cats",
    type: "Reserve",
    status: "White tiger",
    strenght: 99.5,
    stamina: 88.6,
    speed: 45.3,
    health: 0.7
)

/*
 */

leopard.hunt(huntStats: 250)

/*
 */

tiger.experience()
whiteTiger.experience()

/*
 */

leopard.info()
