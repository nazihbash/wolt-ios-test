// 
//  VenuesServiceMock.swift
//  Unit Tests
//
//  Created by Nazih Al Bach on 23.07.23.
//

import Combine

class VenuesServiceMock: VenuesFetchable {  
	var result: AnyPublisher<[VenueItem], ServiceError>? = nil

	func fetch(lat: Double, long: Double) -> AnyPublisher<[VenueItem], ServiceError> {
		if let result {
			return result
		} else {
			fatalError("Service result not set")
		}
	}
}
