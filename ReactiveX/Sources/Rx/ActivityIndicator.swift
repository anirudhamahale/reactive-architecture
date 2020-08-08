//
//  ActivityIndicator.swift
//  ReactiveX
//
//  Created by Anirudha Mahale on 08/08/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class ActivityIndicator: SharedSequenceConvertibleType {
  public typealias Element = Bool
  public typealias SharingStrategy = DriverSharingStrategy
  
  private let _lock = NSRecursiveLock()
  private let _behavior = BehaviorRelay<Bool>(value: false)
  private let _loading: SharedSequence<SharingStrategy, Bool>
  
  public init() {
    _loading = _behavior.asDriver()
      .distinctUntilChanged()
  }
  
  fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
    return source.asObservable()
      .do(onNext: { _ in
        self.sendStopLoading()
      }, onError: { _ in
        self.sendStopLoading()
      }, onCompleted: {
        self.sendStopLoading()
      }, onSubscribe: subscribed)
  }
  
  private func subscribed() {
    _lock.lock()
    _behavior.accept(true)
    _lock.unlock()
  }
  
  private func sendStopLoading() {
    _lock.lock()
    _behavior.accept(false)
    _lock.unlock()
  }
  
  public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
    return _loading
  }
}

extension ObservableConvertibleType {
  public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
    return activityIndicator.trackActivityOfObservable(self)
  }
}

