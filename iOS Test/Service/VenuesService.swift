// 
//  VenuesService.swift
//  iOS Test
//
//  Created by Nazih Al Bach on 21.07.23.
//

import Foundation
import Combine
import CoreLocation

enum ServiceError: Error {
	case invalidURL
	case url(error: URLError)
	case decoder(error: Error)
}

protocol VenuesFetchable {
  func fetch(lat: Double, long: Double) -> AnyPublisher<[VenueItem], ServiceError>
}

struct VenuesService: VenuesFetchable {
	let session: URLSession
	let decoder: JSONDecoder
	
  func fetch(lat: Double, long: Double) -> AnyPublisher<[VenueItem], ServiceError> {
		var components = URLComponents()
		
		components.scheme = Configuration.endpointProtocol
		components.host = Configuration.endpointHost
		components.path = Configuration.endpointPath
    components.queryItems = [
      .init(name: "lat", value: "\(lat)"),
      .init(name: "lon", value: "\(long)")
    ]

		guard let url = components.url else {
			return Fail(error: .invalidURL)
				.eraseToAnyPublisher()
		}
		
		return session
			.dataTaskPublisher(for: URLRequest(url: url))
			.mapError { ServiceError.url(error: $0) }
      .map { $0.data }
			.decode(type: VenuesResponse.self, decoder: decoder)
			.mapError { ServiceError.decoder(error: $0) }
      .map { $0.sections.flatMap { $0.items }}
      .receive(on: RunLoop.main)
			.eraseToAnyPublisher()
	}
}

