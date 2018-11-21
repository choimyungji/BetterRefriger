//
//  FoodListTableViewCell.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2018. 9. 21..
//  Copyright © 2018년 maengji.com. All rights reserved.
//

import UIKit
import SnapKit

class FoodListTableViewCell: UITableViewCell {
  static let rowHeight: CGFloat = 60.0

  var name: String? {
    get {
      return lblFoodName.text
    }
    set {
      lblFoodName.text = newValue
    }
  }

  private var _registerDate: Date?
  var registerDate: Date? {
    get {
      return _registerDate
    }
    set {
      _registerDate = newValue
      if let newValue = newValue {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        lblFoodRegisterDate.text = dateFormatter.string(from: newValue)
      }
    }
  }

  private var _expireDate: Date?
  var expireDate: Date? {
    get {
      return _expireDate
    }
    set {
      _expireDate = newValue
      if let newValue = newValue {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        lblFoodExpireDate.text = dateFormatter.string(from: newValue) + " 까지"
      }
    }
  }

  private var _seq: Int?
  var seq: Int? {
    get {
      return _seq
    }
    set {
      _seq = newValue
    }
  }

  private var lblFoodName: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
    return label
  }()

  private var lblFoodRegisterDate: UILabel = {
    let label = UILabel()
    return label
  }()

  private var lblFoodExpireDate: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    drawUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func drawUI() {
    addSubview(lblFoodName)
    addSubview(lblFoodExpireDate)

    lblFoodName.snp.makeConstraints { maker in
      maker.top.equalToSuperview().inset(12)
      maker.left.right.equalToSuperview().inset(24)
      maker.height.equalTo(21)
    }

    lblFoodExpireDate.snp.makeConstraints { maker in
      maker.top.equalTo(lblFoodName.snp.bottom)
      maker.left.right.equalToSuperview().inset(24)
      maker.height.equalTo(20)
    }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}
