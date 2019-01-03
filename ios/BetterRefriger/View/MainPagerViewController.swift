//
//  MainPagerViewController.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 19/12/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import XLPagerTabStrip
import RxCocoa
import RxSwift

class MainPagerViewController: ButtonBarPagerTabStripViewController {

  let disposeBag = DisposeBag()
  var isReload = false
  var addButton: UIBarButtonItem?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "더나은냉장고"

    addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addFood(_:)))
    addButton?.tintColor = .white
    self.navigationItem.rightBarButtonItem = addButton

    settings.style.buttonBarItemBackgroundColor = .white
    settings.style.buttonBarItemTitleColor = UIColor.darkText
    buttonBarView.selectedBar.backgroundColor = UIColor.BRColorOnActive
    buttonBarView.backgroundColor = .white

    let view = self.view!
    view.backgroundColor = .white
  }

  @objc func addFood(_ sender: AnyObject) {
    guard let mainVC = self.viewControllers[currentIndex] as? MainViewController else {
      return
    }

    mainVC.addFood()
  }

  func setupBinding() {
        addButton?.rx.tap
          .flatMap(selectedColor)
          .observeOn(MainScheduler.instance)
          .subscribe(onNext: { [weak self] food in
            print(food)
//                        self?.save(refrigerType: food.refrigerType.rawValue,
//                                   name: food.foodName,
//                                   registerDate: food.registerDate,
//                                   expireDate: food.expireDate)
            }, onError: { error in
              print(error)
          }, onCompleted: {
            print("completed")
          }).disposed(by: disposeBag)
//    , onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//          .subscribe(onNext: { [weak self] (food) in
//            self?.save(refrigerType: food.refrigerType.rawValue,
//                       name: food.foodName,
//                       registerDate: food.registerDate,
//                       expireDate: food.expireDate)
//          })
//          .disposed(by: disposeBag)
  }



  func selectedColor() -> Observable<FoodInputModel> {
    let foodInputViewModel = FoodInputViewModel()
    let foodInputVC = FoodInputViewController.create(with: foodInputViewModel)
    navigationController?.pushViewController(foodInputVC, animated: true)
    return foodInputVC.inputFood
  }

  // MARK: - PagerTabStripDataSource

  override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
    let refrigerMainViewModel = MainViewModel(refrigerType: .refriger)
    let freezerMainViewModel = MainViewModel(refrigerType: .freezer)

    let child1 = MainViewController.create(with: refrigerMainViewModel)
    let child2 = MainViewController.create(with: freezerMainViewModel)

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
