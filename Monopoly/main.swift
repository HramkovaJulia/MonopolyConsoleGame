//
//  main.swift
//  Monopoly
//
//  Created on 23.02.2023.
//

import Foundation

class Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name: String
    var balance: Int
    var steps = -1
    var properties: [Property]
    init(name: String, balance: Int, position: Int) {
        self.name = name
        self.balance = balance
        self.properties = []
    }
}

class Property {
    let name: String
    var price: Int
    var rent: Int
    var owner: Player?
    var number: Int
    let  color: String
    
    init(name: String, price: Int, rent: Int, owner: Player? = nil, color: String, number: Int) {
        self.name = name
        self.price = price
        self.rent = rent
        self.owner = owner
        self.color = color
        self.number = number
    }
}

class BonusesAndPenalties: Property {
    var money: Int
    init(name: String, owner: Player? = nil, money: Int, number: Int) {
        self.money = money
        super.init(name: name, price: 0, rent: 0, color: "", number: number)
    }
}


class Monopoly {
    var property: [Property]
    var players: [Player]
    var currentPlayerIndex: Int
    var moneyForCircle = 500_000
    init(currentPlayerIndex: Int) {
        players = []
        self.currentPlayerIndex = currentPlayerIndex
        let charynСanyon = Property(name: "Сharyn Сanyon", price: 500_000_000, rent: 3_265_000, owner: nil, color: "purple", number: 1)
        let parkPanfilovtsev = Property(name: "Park 28 Panfilovtsev", price: 550_000_000, rent: 3_665_000, owner: nil, color: "purple", number: 2)
        let undergroundAbay = Property(name: "Abaya Station", price: 500_000_000, rent: 4_265_000, color: "gray", number: 3)
        let pinaltyFirst = BonusesAndPenalties(name: "Fine for beauty", money: 600_000_000, number: 4)
        let bigAlmatyLake = Property(name: "Big Almaty Lake", price: 600_000_000, rent: 4_765_000, owner: nil, color: "purple", number: 5)
        let bonusMoneyFirst = BonusesAndPenalties(name: "Good luck Stop", money:  100_000_000, number: 6)
        let theStateTreathe = Property(name: "The State Treathe", price: 850_000_000, rent: 4_965_000, owner: nil, color: "orange", number: 7)
        let koktobe = Property(name: "Koktobe", price: 850_550_000, rent: 5_965_000, owner: nil, color: "orange", number: 8)
        let undergroundMoskow = Property(name: "Moscow Station", price: 500_000_000, rent: 4_265_000, color: "gray", number: 9)
        let pinaltySecond = BonusesAndPenalties(name: "Stopping is dangerous for the wallet", money: 600_000_000, number: 10)
        let arbat = Property(name: "Arbat", price: 610_000_000, rent: 5_565_000, owner: nil, color: "orange", number: 11)
        let medeo = Property(name: "Medeo", price: 750_000_000, rent: 6_365_000, owner: nil, color: "red", number: 12)
        let bonusMoneySecond = BonusesAndPenalties(name: "Good luck Stop", money: 190_000_000, number: 13)
        let rahatАactory = Property(name: "Rahat Factory", price: 975_000_000, rent: 7_665_000, owner: nil, color: "red", number: 14)
        let undergroundBaikonur = Property(name: "Baikonur Station", price: 500_000_000, rent: 4_265_000, color: "gray", number: 15)
        let tVTower = Property(name: "TV Tower Kok-Tobe", price: 1_090_000_000, rent: 8_065_000, color: "red", number: 16)
        let cathedral = Property(name: "Сathedral", price: 1_305_000_000, rent: 8_565_000, owner: nil, color: "yellow", number: 17)
        let greenBazaar = Property(name: "Green Bazaar", price: 1_590_000_000, rent: 9_065_000, owner: nil, color: "yellow", number: 18)
        let republicPalace = Property(name: "Republic Palace", price: 1_640_000_000, rent: 10_065_000, owner: nil, color: "yellow", number: 19)
        let undergroundZhibekzholy = Property(name: "Zhibekzholy station", price: 500_000_000, rent: 650_000, color: "gray", number: 20)
        
        
        let sortedProperty = [medeo, bigAlmatyLake, arbat, republicPalace, theStateTreathe, koktobe, parkPanfilovtsev, cathedral, greenBazaar, charynСanyon, rahatАactory, tVTower, undergroundAbay, undergroundMoskow, undergroundBaikonur, undergroundZhibekzholy, bonusMoneyFirst, bonusMoneySecond, pinaltyFirst, pinaltySecond].sorted(by: { $0.number < $1.number })
        self.property = []
        for prop in sortedProperty {
            self.property.append(prop)
        }
    }
    
    func addPlayer() {
        print("Enter number of players:")
        if let numPlayers = readLine(), let num = Int(numPlayers) {
            for i in 1...num {
                print("Enter name for Player \(i):")
                if let name = readLine() {
                    let player = Player(name: name, balance: 2_000_000_000, position: 0)
                    players.append(player)
                    print("\(player.name), ваш баланс \(player.balance)")
                    
                }
            }
        }
        
    }
    
    func payRent(currentPlayer: Player, currentSquare: Property) {
        if let owner = currentSquare.owner, owner != currentPlayer, currentPlayer.balance >= currentSquare.rent {
            var rentCount = 0
            for prop in owner.properties where prop.color == currentSquare.color {
                rentCount += 1
            }
            let rent = currentSquare.rent * rentCount
            if currentPlayer.balance >= rent {
                currentPlayer.balance -= rent
                owner.balance += rent
                print("\(currentPlayer.name) paid rent \(rent) tenge to \(owner.name). You have left \(currentPlayer.balance)")
            } else {
                print("\(currentPlayer.name) you lost in this game because you don`t have a money for pay rent ")
                players.remove(at: currentPlayerIndex)
                for property in currentPlayer.properties {
                    returnPropertyToGame(player: currentPlayer, property: property)
                }
            }
        }
    }
    
    func playerProperties(currentPlayer: Player) {
        print("\(currentPlayer.name) you have balance \(currentPlayer.balance)")
        for prop in property {
            if prop.owner == currentPlayer {
                print("\(currentPlayer.name) owns \(prop.name) with \(prop.color)")
            }
        }
    }
    
    func getBonusMoney(currentPlayer: Player, bonus: BonusesAndPenalties) {
        if bonus.money > 0 {
            currentPlayer.balance += bonus.money
            print("Congratulations, walking around the city you found \(String(describing: bonus.money)) money, and now your balance \(currentPlayer.balance)")
        } else if currentPlayer.balance >= bonus.money {
            currentPlayer.balance -= bonus.money
            print("You have chosen the money in the bank, it's time to return it, and now your balance \(currentPlayer.balance)")
        } else {
            print("\(currentPlayer.name) you lost in this game because you can`t pay to bank ")
            players.remove(at: currentPlayerIndex)
            for property in currentPlayer.properties {
                returnPropertyToGame(player: currentPlayer, property: property)
            }
        }
    }
    
    func returnPropertyToGame(player: Player, property: Property) {
        player.properties.append(property)
        property.owner = player
    }
    
    func play() {
        addPlayer()
        while true {
            var currentPlayer = players[currentPlayerIndex]
            print("It's \(currentPlayer.name)'s turn. Press enter to roll the dice.")
            _ = readLine()
            
            // Roll the dice
            let dice1 = Int.random(in: 1...6)
            var steps = dice1
            currentPlayer.steps += steps
            if currentPlayer.steps >= property.count {
                currentPlayer.steps = currentPlayer.steps % property.count
                currentPlayer.balance += 500
            }
            let currentSquare = property[currentPlayer.steps]
            
            print("------------------------------------------------------------------")
            print("\(currentPlayer.name) rolled \(dice1), you are trapped \(currentSquare.name), owner \(String(describing: currentSquare.owner?.name)).")
            playerProperties(currentPlayer: currentPlayer)
            print("------------------------------------------------------------------")
            if currentSquare is BonusesAndPenalties {
                getBonusMoney(currentPlayer: currentPlayer, bonus: (currentSquare as? BonusesAndPenalties)!)
                currentPlayerIndex = (currentPlayerIndex + 1) % players.count
            } else if currentSquare.owner == nil, currentSquare.price <= currentPlayer.balance {
                print("\(currentSquare.name) is unowned, his color \(currentSquare.color). Would you like to buy it for \(currentSquare.price) tenge? (y/n)")
                if let response = readLine(), response.lowercased() == "y" {
                    currentSquare.owner = currentPlayer
                    currentPlayer.balance -= currentSquare.price
                    currentPlayer.properties.append(currentSquare)
                    print("\(currentSquare.name) owner = \(String(describing: currentSquare.owner?.name))")
                }
                currentPlayerIndex = (currentPlayerIndex + 1) % players.count
            } else if let owner = currentSquare.owner, owner != currentPlayer, currentPlayer.balance >= currentSquare.rent {
                payRent(currentPlayer: currentPlayer, currentSquare: currentSquare)
                currentPlayerIndex = (currentPlayerIndex + 1) % players.count
            } else {
                if currentSquare.owner == currentPlayer {
                    print("You have already bought \(currentSquare.name)")
                    currentPlayerIndex = (currentPlayerIndex + 1) % players.count
                } else {
                    print("\(currentPlayer.name) you don't have enough money to buy this property")
                    currentPlayerIndex = (currentPlayerIndex + 1) % players.count
                }
            }
        }
    }
}

let game = Monopoly(currentPlayerIndex: 0)
game.play()
