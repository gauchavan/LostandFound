//
//  AdminReportTableViewCell.swift
//  Lost&Found
//
//  Created by gauri chavan on 4/27/18.
//  Copyright © 2018 gauri chavan. All rights reserved.
//

import UIKit

class AdminReportTableViewCell: UITableViewCell {

    @IBOutlet weak var reportStatus: UILabel!
    @IBOutlet weak var imageReport: UIImageView!
    @IBOutlet weak var subHeadinglabel: UILabel!
    @IBOutlet weak var ReportHeading: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
