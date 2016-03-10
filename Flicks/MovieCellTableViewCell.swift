//
//  MovieCellTableViewCell.swift
//  Flicks
//
//  Created by jacky nguyen on 3/8/16.
//  Copyright © 2016 jacky nguyen. All rights reserved.
//

import UIKit

class MovieCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellIPoster: UIImageView!
    
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var cellReview: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
