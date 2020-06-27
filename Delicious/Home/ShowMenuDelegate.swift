//
//  ShowMenuDelegate.swift
//  Delicious
//
//  Created by Rebecca Cheung on 10/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

// Protocol for which menu the user selects in the collection
protocol ShowMenuDelegate: AnyObject {
    func showMenu(menu: Menu)
}

