// Aleksey Kurto 12.04.2023

import UIKit

/*
 MARK: - mainClass
 */

class Food {
    
    var name: String
    var cost: Double
    var type: String
    
    /*
     */
    
    init(name: String, cost: Double, type: String) {
        self.name = name
        self.cost = cost
        self.type = type
    }
    
    /*
     */
    
    func start() {
        print("You start eat")
    }
    
    /*
     */
    
    func finish() {
        print("You finish eat")
    }
    
    /*
     */
    
    func freshFood() {
        print("Fresh food")
    }
    
    /*
     */
    
    func notFreshFood() {
        print("Not fresh food")
    }
}

/*
 MARK: - otherClass
 */

class Pasta: Food {

    enum ingredients {
        case ketchup
        case cheese
    }
    
    /*
     */
    
    func addToPasta(ingredients: ingredients) {
        switch ingredients {
        case .ketchup:
            print("Ketchup Heinz added to the pasta")
        case .cheese:
            print("Blue cheese added to the pasta")
        }
    }
    
    /*
     */
    
    override func start() {
        print("I start eating a pasta")
    }
    
    /*
     */
    
    override func finish() {
        print("I'm done eating a pasta")
    }
    
    /*
     */
    
    override func freshFood() {
        print("Fresh food - absolutely!")
    }
    
    /*
     */
    
    override func notFreshFood() {
        print("Not fresh food - sorry")
    }
}

/*
 MARK: - otherClass
 */

class Salad: Food {

    override func start() {
        print("You start eat a salad")
    }
    
    /*
     */
    
    override func finish() {
        print("You finish eat a salad")
    }
    
    /*
     */
    
    override func freshFood() {
        print("My salad - always fresh")
    }
    
    /*
     */
    
    override func notFreshFood() {
        print("Impossible")
    }
}

/*
 MARK: - protocol
 */

protocol processEat {
    
    var name: String { get set }
    
    /*
     */
    
    func start()
    func finish()
    func doubleSalad()
    func tripleSpaghetti()
}

/*
 MARK: - extension
 */

extension Salad: processEat {
    
    func doubleSalad() {
        print("Double salad alredy")
    }
    
    /*
     */
    
    func tripleSpaghetti() {
        print("Triple salad alredy")
    }
}


let salad = Salad(name: "Grec", cost: 2.6, type: "HF")
let pasta = Pasta(name: "Spaghetti", cost: 1.3, type: "Regular")

salad.doubleSalad()
pasta.addToPasta(ingredients: .cheese)
print(salad.name)
