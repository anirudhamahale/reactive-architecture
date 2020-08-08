//
//  HomeViewController.swift
//  ReactiveX
//
//  Created by Anirudha Mahale on 02/08/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
  
  deinit {
    print("HomeViewController deinit")
  }
  
  private let disposeBag = DisposeBag()
  
  var viewModel: HomeViewModel!
  @IBOutlet weak var loadingView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    viewModel = HomeViewModel(repository: SyncRepository())
    
    let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
      .mapToVoid()
    // .asDriverOnErrorJustComplete()
    
    let retry = PublishSubject<Void>()
    
    let input = HomeViewModel.Input(fetchMovies: viewDidAppear, retry: retry.asObservable())
    let output = viewModel.transform(input: input)
    
    output.syncSuccess
      .do(onNext: { (value) in
        print("onNext: \(value)")
      }, afterNext: { (value) in
        print("afterNext: \(value)")
      }, onError: { (error) in
        print("onError: \(error)")
      }, afterError: { (error) in
        print("afterError: \(error)")
      }, onCompleted: {
        print("onCompleted")
      }, afterCompleted: {
        print("afterCompleted")
      }, onSubscribe: {
        print("onSubscribe")
      }, onSubscribed: {
        print("onSubscribed")
      }, onDispose: {
        print("onDispose")
      })
      .flatMapFirst { [unowned self] (message) -> Observable<Void> in
        let (alert, trigger) = self.createAlert(message: message)
        self.present(alert, animated: true)
        return trigger
    }.subscribe(retry)
      .disposed(by: disposeBag)
    
    output.loading
      .map({ !$0 })
      .bind(to: loadingView.rx.isHidden)
      .disposed(by: disposeBag)
  }
  
  func createAlert(message: String) -> (UIViewController, Observable<Void>) {
    let trigger = PublishSubject<Void>()
    let alert = UIAlertController(title: "Sync failed!",
                                  message: message,
                                  preferredStyle: .alert)
    let okay = UIAlertAction(title: "Retry", style: .default, handler: { _ in
      trigger.onNext(())
      trigger.onCompleted()
    })
    let dismiss = UIAlertAction(title: "Dismiss",
                                style: UIAlertAction.Style.cancel,
                                handler: nil)
    
    alert.addAction(okay)
    alert.addAction(dismiss)
    return (alert, trigger)
  }
  
}

