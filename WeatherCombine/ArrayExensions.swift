//
//  ArrayExensions.swift
//  WeatherCombine
//
//  Created by Derrick Ho on 1/5/20.
//  Copyright © 2020 Derrick Ho. All rights reserved.
//

import Foundation
import Combine

infix operator <-: AdditionPrecedence

extension Array where Element == AnyCancellable {
    static func <-(lhs: inout Array<Element>, rhs: Element) {
        lhs.append(rhs)
    }
}
