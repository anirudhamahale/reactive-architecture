//
//  MoviesViewController.swift
//  ReactiveX
//
//  Created by Anirudha Mahale on 13/08/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesViewController: UIViewController {
  
  @IBOutlet weak var refreshButton: UIBarButtonItem!
  
  private let disposeBag = DisposeBag()
  var viewModel: MoviesViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    viewModel = MoviesViewModel(repository: SyncRepository())
    
    let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
    .mapToVoid()
    .asDriverOnErrorJustComplete()
    
    let refresh = refreshButton.rx.tap.asDriver()
    
    let input = MoviesViewModel.Input(fetchMovies: Driver.merge(viewDidAppear, refresh))
    let output = viewModel.transform(input: input)
    
    output.movieSection.asDriver()
      .drive(onNext: { (state) in
        print(state)
      }, onCompleted: {
        print("onCompleted")
      }, onDisposed:  {
        print("onDisposed")
      }).disposed(by: disposeBag)
  }
}
