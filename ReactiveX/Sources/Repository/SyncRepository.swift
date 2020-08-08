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
  func sync() -> Observable<String> {
    return Observable.of("Successfully Synced data.")
    .delay(.seconds(3), scheduler: MainScheduler.instance)
  }
  
  func error() -> Observable<String> {
    let userInfo = [NSLocalizedDescriptionKey : "You need to obtain the user key."]
    return Observable.error(NSError(domain: "", code: 400, userInfo: userInfo))
    .delay(.seconds(3), scheduler: MainScheduler.instance)
  }
}
