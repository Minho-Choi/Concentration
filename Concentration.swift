//
//  Concentration.swift
//  Concentration
//
//  Created by Minho Choi on 2020/07/03.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int) -> Int {
        var scoreCalc = 0
        cards[index].isShown += 1
        if cards[index].isShown >= 2 {
            scoreCalc += -1
        }
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                //check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    scoreCalc += 2
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                //either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        return scoreCalc
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // TODO: Shuffle the cards
        for index in 0..<numberOfPairsOfCards {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            let cache = cards[randomIndex]
            cards[randomIndex] = cards[2*index + 1]
            cards[2*index + 1] = cache
        }
    }
    
}
