//
//  Protocols.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 14/04/23.
//

import Foundation

protocol HamburgerVCDelegate {
    func selectedCell(_ row: Int)
}

protocol CurrentUser {
    func activeUser(_ email: String)
}
