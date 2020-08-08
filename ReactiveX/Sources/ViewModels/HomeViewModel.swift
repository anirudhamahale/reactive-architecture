//
//  HomeViewModel.swift
//  ReactiveX
//
//  Created by Anirudha Mahale on 03/08/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType {
  
  deinit {
    print("HomeViewModel deinit")
  }
  
  struct Input {
    let fetchMovies: Driver<Void>
    let retry: Driver<Void>
  }
  
  struct Output {
    let syncSuccess: Driver<String>
    let loading: Driver<Bool>
    let error: Driver<Error>
  }
  
  var repository: SyncRepository
  
  init(repository: SyncRepository) {
    self.repository = repository
  }
  
  func transform(input: Input) -> Output {
    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    
    let syncSuccess = Driver.merge(input.fetchMovies, input.retry)
    .flatMapLatest { [unowned self] in
      return self.repository.failure()
        .trackActivity(activityIndicator)
        .trackError(errorTracker)
        .asDriverOnErrorJustComplete()
        .map { $0 }
    }

    return Output(syncSuccess: syncSuccess, loading: activityIndicator.asDriver(), error: errorTracker.asDriver())
  }
}
