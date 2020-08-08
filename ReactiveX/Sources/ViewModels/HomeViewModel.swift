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
    let fetchMovies: Observable<Void>
    let retry: Observable<Void>
  }
  
  struct Output {
    let syncSuccess: Observable<String>
    let loading: Observable<Bool>
  }
  
  var repository: SyncRepository
  
  init(repository: SyncRepository) {
    self.repository = repository
  }
  
  func transform(input: Input) -> Output {
    let loadingSubject = PublishSubject<Bool>()
    
    let fetching = Observable.merge(input.fetchMovies, input.retry)
      .flatMapLatest { [unowned self] _ -> Observable<String> in
        loadingSubject.onNext(true)
        return self.repository.sync()
          .map { (value) -> String in
            loadingSubject.onNext(false)
            return value
        }.catchError { (error) -> Observable<String> in
          loadingSubject.onNext(false)
          return Observable.just(error.localizedDescription)
          // return Observable.of(error.localizedDescription)
        }.map({ $0 })
    }
    return Output(syncSuccess: fetching, loading: loadingSubject.asObservable())
  }
}
