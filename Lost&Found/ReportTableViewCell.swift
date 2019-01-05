//
//  ReportTableViewCell.swift
//  Lost&Found
//
//  Created by gauri chavan on 4/27/18.
//  Copyright © 2018 gauri chavan. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var reportStatus: UILabel!
    @IBOutlet weak var reportImageViewer: UIImageView!
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var subTitleTextField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
