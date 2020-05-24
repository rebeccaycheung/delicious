//
//  IngredientsTableViewCell.swift
//  Delicious
//
//  Created by Rebecca Cheung on 24/5/20.
//  Copyright © 2020 Rebecca Cheung. All rights reserved.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var measurementLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
