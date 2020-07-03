//
//  ViewController.swift
//  Concentration
//
//  Created by Minho Choi on 2020/07/02.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Scores: \(score)"
        }
    }
    
    var emojiSet = [["🐶","🐱","🐭","🐸","🦊","🐻","🐷","🐵","🐔","🐧"],//Zoo
        ["🐝","🐛","🦋","🐞","🐜","🕷","🦂","🦟","🦗","🐌"],//Bug
        ["🕶","🌂","👑","💼","🎩","👠","🧦","🧤","🧣","💍"],//Things
        ["🍆","🥕","🥦","🌽","🥒","🌶","🧅","🥑","🥬","🧄"],//Veges
        ["🍔","🍣","🍕","🍖","🌮","🍜","🥘","🍟","🧇","🍳"],//Foods
        ["⚽️","🏀","🏈","⚾️","🥎","🎾","🏐","🏉","🎱","🏓"]]//Sports
    
    func randomEmojiFactory(of themeSet: [[String]]) -> [String] {
        let index = Int(arc4random_uniform(UInt32(themeSet.count)))
        return themeSet[index]
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!                              // Array<UIButton>! 과 같은 뜻
    
    @IBAction func touchCard(_ sender: UIButton) {                      // _underbar 있는 이유는 objective C의 잔재
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            score += game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Not in cardButtons")
        }
        
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        flipCount = 0
        score = 0
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        emojiChoices = randomEmojiFactory(of: emojiSet)
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    lazy var emojiChoices = randomEmojiFactory(of: emojiSet)
    
    var emoji = [Int:String]()
    
    func emoji(for card: Card) -> String {
        
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
}

