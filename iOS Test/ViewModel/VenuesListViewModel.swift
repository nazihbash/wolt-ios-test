// 
//  VenuesListViewModel.swift
//  iOS Test
//
//  Created by Nazih Al Bach on 21.07.23.
//

import Foundation
import Combine
import SwiftUI
import CoreLocation

enum VenuesError: LocalizedError {
	case serviceError
	case decodingError

	init(error: ServiceError) {
		switch error {
		case .invalidURL, .url(_):
			self = .serviceError
		case .decoder(_):
			self = .decodingError
		}
	}
	
	var errorDescription: String? {
		switch self {
		case .serviceError:
			return "Service Error".localized
		case .decodingError:
			return "Decoding Error".localized
		}
  }

	var errorMessage: String? {
		return "Something went wrong.".localized
	}
}

class VenuesListViewModel: ObservableObject {
	let service: VenuesFetchable
  private let locationManager: LocationManager
	@Published var venues: [VenueViewModel] = []
	@Published var error: VenuesError?
	@Published var isLoading: Bool = true
	private var cancellable: AnyCancellable?

	init(
    service: VenuesFetchable,
    locationManager: LocationManager
  ) {
		self.service = service
    self.locationManager = locationManager
	}
	  
	func viewDidAppear() {
    locationManager.delegate = self
    fetchVenues(from: locationManager.currentLocation)
	}
	
  private func fetchVenues(from location: CLLocationCoordinate2D?) {
    guard let location = location else { return }
		isLoading = true
		cancellable = service
      .fetch(lat: location.latitude, long: location.longitude)
			.sink { [weak self] completion in
				guard let self = self else { return }
				self.isLoading = false
				switch completion {
				case .finished:
					break
				case .failure(let error):
					self.error = .init(error: error)
				}
			} receiveValue: { [weak self] venues in
        var finalVenues = [VenueViewModel]()
        venues.forEach {
          if let venue = $0.venue, let image = $0.image {
            finalVenues.append(.init(venue: venue, image: image))
          }
        }
        self?.venues = Array(finalVenues.prefix(Configuration.maxDisplayedVenues))
			}
	}
	
	func toggleFavoriteStatus(for venueId: String) {
		guard let venue = venues.first(where: { $0.venueId == venueId }) else { return }
    venue.isFavorite = !venue.isFavorite
		if let index = venues.firstIndex(of: venue) {
      venues[index] = venue
		}
	}
}
extension VenuesListViewModel: LocationManagerDelegate {
  func didLocationChange(_ newLocation: CLLocationCoordinate2D) {
    fetchVenues(from: newLocation)
  }
}
