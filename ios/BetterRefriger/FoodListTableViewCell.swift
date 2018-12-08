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

        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: expireDate!)
        let components = calendar.dateComponents([.day], from: date1, to: date2)

        guard let day = components.day else { return }

        if day > 7 {
          lblNearExpire.type = .normal
        } else if day > 0 {
          lblNearExpire.type = .nearExpire
        } else {
          lblNearExpire.type = .expired
        }
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

  private var lblNearExpire = FoodStatusLabel()

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
    addSubview(lblNearExpire)

    lblFoodName.snp.makeConstraints { maker in
      maker.top.equalToSuperview().inset(12)
      maker.left.right.equalToSuperview().inset(24)
      maker.height.equalTo(21)
    }

    lblFoodExpireDate.snp.makeConstraints { maker in
      maker.top.equalTo(lblFoodName.snp.bottom)
      maker.left.equalToSuperview().inset(24)
      maker.height.equalTo(20)
    }

    lblNearExpire.snp.makeConstraints {
      $0.top.equalTo(lblFoodExpireDate)
      $0.left.equalTo(lblFoodExpireDate.snp.right).offset(10)
      $0.height.equalTo(lblFoodExpireDate)
    }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}

enum FoodStatus {
  case normal, nearExpire, expired
}

@IBDesignable class FoodStatusLabel: UILabel {

  var type: FoodStatus = .normal {
    didSet {
      switch type {
      case .normal:
        isHidden = true
      case .nearExpire:
        isHidden = false
        backgroundColor = UIColor.BRColorOnWarning
        text = "마감임박"
      case .expired:
        isHidden = false
        backgroundColor = UIColor.BRColorOnError
        text = "유통기한지남"
      }
    }
  }
  @IBInspectable var topInset: CGFloat = 0.0
  @IBInspectable var bottomInset: CGFloat = 0.0
  @IBInspectable var leftInset: CGFloat = 3.0
  @IBInspectable var rightInset: CGFloat = 3.0

  override init(frame: CGRect) {
    super.init(frame: frame)
    drawUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func drawUI() {
    textColor = UIColor.white
    font = UIFont.systemFont(ofSize: 12)

    layer.masksToBounds = true
    layer.cornerRadius = 2

    sizeToFit()
  }

  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets.init(top: topInset,
                                   left: rightInset,
                                   bottom: bottomInset,
                                   right: rightInset)
    super.drawText(in: rect.inset(by: insets))
  }

  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + leftInset + rightInset,
                  height: size.height + topInset + bottomInset)
  }
}
