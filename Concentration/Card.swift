//
//  Card.swift
//  Concentration
//
//  Created by Minho Choi on 2020/07/03.
//  Copyright © 2020 Minho Choi. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var hashValue: Int { return identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    var isShown = 0
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {          // static 함수는 type에 대한 함수
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()        //self 의미는 struct의 instance인 identifier
    }
    
}

