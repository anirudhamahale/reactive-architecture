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

  struct Input {
    let fetchMovies: Observable<Void>
    let retry: Observable<Void>
  }
  
  struct Output {
    let syncSuccess: Observable<String>
  }
  
  var repository: SyncRepository
  
  init(repository: SyncRepository) {
    self.repository = repository
  }
  
  func transform(input: Input) -> Output {
    let fetching = Observable.merge(input.fetchMovies, input.retry)
        .flatMapLatest { _ -> Observable<String> in
            return Observable<String>.from(optional: "Choose below options to proceed") // This message will be returned by server.
                .delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    return Output(syncSuccess: fetching)
  }
}
