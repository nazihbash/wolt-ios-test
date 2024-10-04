// 
//  String+Extensions.swift
//  iOS Test
//
//  Created by Nazih Al Bach on 21.07.23.
//

import Foundation

extension String {
  var localized: String {
    NSLocalizedString(self, comment: "")
  }
}
