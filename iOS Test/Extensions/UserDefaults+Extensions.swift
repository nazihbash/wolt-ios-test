//
//  UserDefaults+Extensions.swift
//  iOS Test
//
//  Created by Nazih Al Bach on 02.10.24.
//

import Foundation

extension UserDefaults {
  private enum Keys: String {
    case favorites
  }

  class var favorites: [String] {
    get {
      return UserDefaults.standard.stringArray(forKey: Keys.favorites.rawValue) ?? [String]()
    }
    set {
      UserDefaults.standard.set(newValue, forKey: Keys.favorites.rawValue)
      UserDefaults.standard.synchronize()
    }
  }
}
