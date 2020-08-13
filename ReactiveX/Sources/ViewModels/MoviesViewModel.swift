//
//  MoviesViewModel.swift
//  ReactiveX
//
//  Created by Anirudha Mahale on 13/08/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MoviesViewModel: ViewModelType {
  
  deinit {
    print("HomeViewModel deinit")
  }
  
  struct Input {
    let fetchMovies: Driver<Void>
  }
  
  struct Output {
    let movieSection: Driver<MoviesViewModelState>
  }
  
  var repository: SyncRepository
  private var names: [String] = []
  private let disposeBag = DisposeBag()
  
  init(repository: SyncRepository) {
    self.repository = repository
  }
  
  func transform(input: Input) -> Output {
    let movieSection = PublishSubject<MoviesViewModelState>()
    
    input.fetchMovies
      .asObservable()
      .flatMapLatest { [unowned self] _ -> Observable<[String]> in
        if self.names.count > 0 {
          movieSection.onNext(.loadRemaining)
        } else {
          movieSection.onNext(.loading)
        }
        return self.repository.names()
    }.subscribe(onNext: { [unowned self] (names: [String]) in
      self.names.append(contentsOf: names)
      movieSection.onNext(.loaded(self.names))
    }).disposed(by: disposeBag)
    
    return Output(movieSection: movieSection.asDriverOnErrorJustComplete())
  }
}

enum MoviesViewModelState {
  case loading
  case loaded([String])
  case loadRemaining
}
