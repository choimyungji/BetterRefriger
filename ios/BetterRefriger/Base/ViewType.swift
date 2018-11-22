//
//  ViewType.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 22/11/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import UIKit
import RxSwift

protocol ViewType: class {
  associatedtype ViewModelType
  var viewModel: ViewModelType! { get set }
  var disposeBag: DisposeBag! { get set }
  func setupUI()
  func setupEventBinding()
  func setupUIBinding()
}

extension ViewType where Self: UIViewController {
  static func create(with viewModel: ViewModelType) -> Self {
    let `self` = Self()
    self.viewModel = viewModel
    self.disposeBag = DisposeBag()
    self.loadViewIfNeeded()
    self.setupUI()
    self.setupEventBinding()
    self.setupUIBinding()
    return self
  }
}


