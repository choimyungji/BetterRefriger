//
//  FoodListTableViewCell.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2018. 9. 21..
//  Copyright © 2018년 maengji.com. All rights reserved.
//

import UIKit

class FoodListTableViewCell: UITableViewCell {
    var name : String?
    var registerDate: Date?
    var expireDate: Date?

    private var lblFoodName = UILabel()
    private var lblFoodRegisterDate = UILabel()
    private var lblFoodExpireDate = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        lblFoodName.frame = CGRect(x: 5, y: 5, width: 100, height: 40)
        lblFoodRegisterDate.frame = CGRect(x: 5, y: 50, width: 100, height: 20)
        lblFoodExpireDate.frame = CGRect(x: 110, y: 50, width: 100, height: 20)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
