// 
//  VenuesMocks.swift
//  Unit Tests
//
//  Created by Nazih Al Bach on 23.07.23.
//

import Foundation

struct VenuesMock {
	static let venues1: [VenueItem] = [
		.init(id: "1"),
		.init(id: "2"),
		.init(id: "3"),
		.init(id: "4"),
		.init(id: "5"),
		.init(id: "6"),
		.init(id: "7"),
		.init(id: "8"),
		.init(id: "9"),
	]
	
  static let venues2: [VenueItem] = [
    .init(id: "10"),
    .init(id: "11"),
    .init(id: "12"),
    .init(id: "13"),
    .init(id: "14"),
    .init(id: "15"),
    .init(id: "16"),
    .init(id: "17"),
    .init(id: "18"),
  ]
}
fileprivate extension VenueItem {
	init(id: String) {
    self.venue = .init(id: id, name: "", shortDescription: "")
		self.image = VenueImage(url: "")
	}
}
