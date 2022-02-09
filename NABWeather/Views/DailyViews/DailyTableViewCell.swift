//
//  DailyTableViewCell.swift
//  NABWeather
//
//  Created by Omnimobile on 1/26/22.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbAvg: UILabel!
    @IBOutlet weak var lbPressure: UILabel!
    @IBOutlet weak var lbHumidty: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
