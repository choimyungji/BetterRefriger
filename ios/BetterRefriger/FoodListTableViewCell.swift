//
//  FoodListTableViewCell.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2018. 9. 21..
//  Copyright © 2018년 maengji.com. All rights reserved.
//

import UIKit

class FoodListTableViewCell: UITableViewCell {
    static let rowHeight = 80.0
    
    var name: String? {
        get {
            return lblFoodName.text
        }
        set(newVal) {
            lblFoodName.text = newVal
        }
    }

    private var _registerDate: Date?
    var registerDate: Date? {
        get {
            return _registerDate
        }
        set(newVal) {
            _registerDate = newVal
            if let newVal = newVal {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                lblFoodRegisterDate.text = dateFormatter.string(from: newVal)
            }
        }
    }

    private var _expireDate: Date?
    var expireDate: Date? {
        get {
            return _expireDate
        }
        set(newVal) {
            _expireDate = newVal
            if let newVal = newVal {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                lblFoodExpireDate.text = dateFormatter.string(from: newVal)
            }
        }
    }

    private var lblFoodName = UILabel()
    private var lblFoodRegisterDate = UILabel()
    private var lblFoodExpireDate = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        lblFoodName.frame = CGRect(x: 5, y: 5, width: 100, height: 40)
        lblFoodRegisterDate.frame = CGRect(x: 5, y: 50, width: 100, height: 20)
        lblFoodExpireDate.frame = CGRect(x: 110, y: 50, width: 100, height: 20)

        addSubview(lblFoodName)
        addSubview(lblFoodRegisterDate)
        addSubview(lblFoodExpireDate)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
