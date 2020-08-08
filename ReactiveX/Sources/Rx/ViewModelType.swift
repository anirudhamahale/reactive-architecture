//
//  ViewModelType.swift
//  ReactiveX
//
//  Created by Anirudha Mahale on 03/08/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
