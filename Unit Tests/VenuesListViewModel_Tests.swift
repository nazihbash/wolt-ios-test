import XCTest
import Combine

class VenuesListViewModel_Tests: XCTestCase {
	var sut: VenuesListViewModel!
	var service: VenuesServiceMock!
	
	override func setUp() {
		super.setUp()
		service = VenuesServiceMock()
		sut = VenuesListViewModel(service: service, locationManager: LocationManager())
	}
	
	func testOnViewDidAppear_WithSuccessfulAPI() {
		let venues = VenuesMock.venues1
		service.result = CurrentValueSubject(venues).eraseToAnyPublisher()
		sut.viewDidAppear()
    XCTAssertEqual(sut.venues, venues.map { VenueViewModel(venue: $0.venue!, image: $0.image!) })
		XCTAssertNil(sut.error)
	}
	
	func testOnViewDidAppear_WithFailedAPI() {
		let serviceError = ServiceError.invalidURL
		service.result = Fail(error: serviceError).eraseToAnyPublisher()
		sut.viewDidAppear()
		XCTAssertTrue(sut.venues.isEmpty)
		XCTAssertEqual(sut.error, VenuesError(error: serviceError))
	}

  func testToggleFavoriteStatus() {
    let venues = VenuesMock.venues1
    service.result = CurrentValueSubject(venues).eraseToAnyPublisher()
    sut.viewDidAppear()
    let isFavorite = sut.venues[0].isFavorite
    sut.toggleFavoriteStatus(for: sut.venues[0].venueId)
    XCTAssertNotEqual(sut.venues[0].isFavorite, isFavorite)
  }

  func testLocationChanged() {
    let venues = VenuesMock.venues1
    service.result = CurrentValueSubject(venues).eraseToAnyPublisher()
    sut.viewDidAppear()
    XCTAssertEqual(sut.venues, venues.map { VenueViewModel(venue: $0.venue!, image: $0.image!) })
    XCTAssertNil(sut.error)
    let venues2 = VenuesMock.venues2
    service.result = CurrentValueSubject(venues2).eraseToAnyPublisher()
    let exp = expectation(description: "Test after \(Configuration.locationChangeDuration) seconds")
    let result = XCTWaiter.wait(for: [exp], timeout: TimeInterval(Configuration.locationChangeDuration))
    if result == XCTWaiter.Result.timedOut {
      XCTAssertEqual(sut.venues, venues2.map { VenueViewModel(venue: $0.venue!, image: $0.image!) })
      XCTAssertNil(sut.error)
    } else {
        XCTFail("Delay interrupted")
    }
  }
}
