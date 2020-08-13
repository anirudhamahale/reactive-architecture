//
//  SyncRepository.swift
//  ReactiveX
//
//  Created by Anirudha Mahale on 03/08/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import RxSwift

class SyncRepository {
  func success() -> Observable<String> {
    return Observable<String>.create { (observer) -> Disposable in
      DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
        observer.onNext("Your element of surprise.")
      })
      return Disposables.create()
    }
  }
  
  func failure() -> Observable<String> {
    return Observable<String>.create { (observer) -> Disposable in
      DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
        let userInfo = [NSLocalizedDescriptionKey : "You are not authorized."]
        observer.onError(NSError(domain: "", code: 401, userInfo: userInfo))
      })
      return Disposables.create()
    }
  }
  
  func names() -> Observable<[String]> {
     return .create { (observer) -> Disposable in
       DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
        observer.onNext(["Jay", "Ho"])
       })
       return Disposables.create()
     }
   }
}
