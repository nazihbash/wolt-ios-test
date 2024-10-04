//
//  VenueViewModel.swift
//  iOS Test
//
//  Created by Nazih Al Bach on 04.10.24.
//

import Foundation

class VenueViewModel: Identifiable, ObservableObject, Equatable {
  private let venue: Venue
  private let image: VenueImage
  @Published var isSelected = false

  init(venue: Venue, image: VenueImage) {
    self.venue = venue
    self.image = image
  }

  let id = UUID()

  var venueId: String {
    venue.id
  }

  var name: String {
    venue.name
  }

  var description: String? {
    venue.shortDescription
  }

  var imageURL: String {
    image.url
  }

  var isFavorite: Bool {
    get {
      UserDefaults.favorites.contains(where: { $0 == venueId })
    }
    set {
      var favorites = UserDefaults.favorites
      if newValue {
        favorites.append(venueId)
      } else {
        favorites.removeAll(where: { $0 == venueId })
      }
      UserDefaults.favorites = favorites
    }
  }

  static var `default` = VenueViewModel(
    venue: Venue(id: "1", name: "Test name", shortDescription: "Test description"),
    image: VenueImage(url: "https://prod-wolt-venue-images-cdn.wolt.com/5cc175b2daaaee24fdbb92ee/0746696e-0045-11ee-8c69-2abb24723ee4_taco_bell.png")
    )

  static func ==(lhs: VenueViewModel, rhs: VenueViewModel) -> Bool {
    return lhs.venueId == rhs.venueId
  }
}
