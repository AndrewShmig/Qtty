//
//  DictionaryExtension.swift
//  Qtty
//
//  Created by AndrewShmig on 28/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import Foundation

@assignment func += <T, G>(inout left: [T: G], right: [T: G]) {
  for (key, value) in right {
    left[key] = value
  }
}