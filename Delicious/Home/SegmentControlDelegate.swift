//
//  SegmentControlDelegate.swift
//  Delicious
//
//  Created by Rebecca Cheung on 6/6/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import Foundation

// Protocol for which segement control was selected
protocol SegmentControlDelegate: AnyObject {
    func segmentControl(recipe: Bool)
}
