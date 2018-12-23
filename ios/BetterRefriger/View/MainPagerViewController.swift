//
//  MainPagerViewController.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 19/12/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import XLPagerTabStrip

class MainPagerViewController: ButtonBarPagerTabStripViewController {
  var isReload = false

  override func viewDidLoad() {
    super.viewDidLoad()

    buttonBarView.selectedBar.backgroundColor = .orange
    buttonBarView.backgroundColor = UIColor(red: 7/255, green: 185/255, blue: 155/255, alpha: 1)
    self.navigationController?.navigationBar.isTranslucent = true

    let view = self.view!
    view.backgroundColor = .white
  }

  // MARK: - PagerTabStripDataSource

  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let mainViewModel = MainViewModel()
    let child1 = MainViewController.create(with: mainViewModel)
    let child2 = MainViewController.create(with: mainViewModel)

    guard isReload else {
      return [child1, child2]
    }

    var childViewControllers = [child1, child2]

    for index in childViewControllers.indices {
      let nElements = childViewControllers.count - index
      let number = (Int(arc4random()) % nElements) + index
      if number != index {
        childViewControllers.swapAt(index, number)
      }
    }
    let nItems = 1 + (arc4random() % 8)
    return Array(childViewControllers.prefix(Int(nItems)))
  }

  override func reloadPagerTabStripView() {
    isReload = true
    if arc4random() % 2 == 0 {
      pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
    } else {
      pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
    }
    super.reloadPagerTabStripView()
  }
}
