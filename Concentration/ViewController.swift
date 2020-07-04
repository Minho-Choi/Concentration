//
//  ViewController.swift
//  Concentration
//
//  Created by Minho Choi on 2020/07/02.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCount()
        }
    }
    
    private func updateFlipCount() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private(set) var score = 0 {
        didSet {
            scoreLabel.text = "Scores: \(score)"
        }
    }
    
    private var emojiSet = ["🐶🐱🐭🐸🦊🐻🐷🐵🐔🐧",//Zoo
        "🐝🐛🦋🐞🐜🕷🦂🦟🦗🐌",//Bug
        "🕶🌂👑💼🎩👠🧦🧤🧣💍",//Things
        "🍆🥕🥦🌽🥒🌶🧅🥑🥬🧄",//Veges
        "🍔🍣🍕🍖🌮🍜🥘🍟🧇🍳",//Foods
        "⚽️🏀🏈⚾️🥎🎾🏐🏉🎱🏓"]//Sports
    
    private func randomEmojiFactory(of themeSet: [String]) -> String {
        let index = Int(arc4random_uniform(UInt32(themeSet.count)))
        return themeSet[index]
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCount()
        }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!                              // Array<UIButton>! 과 같은 뜻
    
    @IBAction private func touchCard(_ sender: UIButton) {                      // _underbar 있는 이유는 objective C의 잔재
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            score += game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Not in cardButtons")
        }
        
    }
    
    @IBAction private func restartGame(_ sender: UIButton) {
        flipCount = 0
        score = 0
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        emojiChoices = randomEmojiFactory(of: emojiSet)
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
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
    
    private lazy var emojiChoices = randomEmojiFactory(of: emojiSet)
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
