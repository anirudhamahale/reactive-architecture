//
//  RxAnimatableTableSectionModel.swift
//  ReactiveX
//
//  Created by Anirudha Mahale on 13/08/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

struct RxAnimatableTableSectionModel {
  var header: String
  var rows: [RxAnimatableTableCellModel]
  
  var rowsCount: Int {
    return rows.count
  }
  
  mutating func append(_ model: RxAnimatableTableCellModel) {
    rows.append(model)
  }
  
  mutating func removeItems(at indexs: [Int]) {
    indexs.forEach({ rows.remove(at: $0) })
  }
}

class RxAnimatableTableCellModel: IdentifiableType, Equatable {
  var identity: String {
    return id
  }
  
  var id = ""
  typealias Identity = String
  
  static func == (lhs: RxAnimatableTableCellModel, rhs: RxAnimatableTableCellModel) -> Bool {
    return lhs.id == rhs.id
  }
  
  func getIndex(from constant: String) -> Int? {
    let stringIndex = identity.replacingOccurrences(of: constant, with: "")
    return Int(stringIndex)
  }
}
