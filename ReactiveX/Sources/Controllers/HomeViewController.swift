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
  let retry = PublishSubject<Void>()
  
  var viewModel: HomeViewModel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    viewModel = HomeViewModel(repository: SyncRepository())
    
    let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
      .mapToVoid()
      .asDriverOnErrorJustComplete()
    
    let input = HomeViewModel.Input(fetchMovies: viewDidAppear, retry: retry.asDriverOnErrorJustComplete())
    let output = viewModel.transform(input: input)
    
    output.loading
      .skip(1)
      .map({ $0 ? "Loading..." : "Loaded!" })
      .drive(rx.title)
      .disposed(by: disposeBag)
    
    output.loading
      .drive(activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)
    
    output.syncSuccess
      .drive(alert)
      .disposed(by: disposeBag)
    
    output.error
      .drive(error)
      .disposed(by: disposeBag)
  }
  
  var alert: Binder<String> {
    return Binder(self) { (vc, message) in
      let alert = UIAlertController(title: "Sync failed!",
                                    message: message,
                                    preferredStyle: .alert)
      let okay = UIAlertAction(title: "Retry", style: .default, handler: { _ in
        vc.retry.onNext(())
      })
      let dismiss = UIAlertAction(title: "Dismiss",
                                  style: UIAlertAction.Style.cancel,
                                  handler: nil)
      
      alert.addAction(okay)
      alert.addAction(dismiss)
      vc.present(alert, animated: true, completion: nil)
    }
  }
  
  var error: Binder<Error> {
    return Binder(self) { (vc, error) in
      let alert = UIAlertController(title: "Sync failed!",
                                    message: error.localizedDescription,
                                    preferredStyle: .alert)
      let okay = UIAlertAction(title: "Retry", style: .default, handler: { _ in
        vc.retry.onNext(())
      })
      let dismiss = UIAlertAction(title: "Dismiss",
                                  style: UIAlertAction.Style.cancel,
                                  handler: nil)
      
      alert.addAction(okay)
      alert.addAction(dismiss)
      vc.present(alert, animated: true, completion: nil)
    }
  }
}

