// 
//  Venue.swift
//  iOS Test
//
//  Created by Nazih Al Bach on 21.07.23.
//

import Foundation

struct VenuesResponse: Decodable {
  let sections: [VenueSection]
}

struct VenueSection: Decodable {
  let items: [VenueItem]
}

struct VenueItem: Decodable {
  let venue: Venue?
  let image: VenueImage?
}

struct VenueImage: Decodable {
  let url: String
}

struct Venue: Decodable {
	let id: String
	let name: String
	let shortDescription: String?

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case shortDescription = "short_description"
	}
}
