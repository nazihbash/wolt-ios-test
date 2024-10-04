//
//  LocationManager.swift
//  iOS Test
//
//  Created by Nazih Al Bach on 03.10.24.
//

import Foundation
import CoreLocation
import Combine

protocol LocationManagerDelegate: AnyObject {
  func didLocationChange(_ newLocation: CLLocationCoordinate2D)
}

final class LocationManager {

  private let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)

  private let locations = [
    CLLocationCoordinate2D(latitude: 60.170187, longitude: 24.930599),
    CLLocationCoordinate2D(latitude: 60.169418, longitude: 24.931618),
    CLLocationCoordinate2D(latitude: 60.169818, longitude: 24.932906),
    CLLocationCoordinate2D(latitude: 60.170005, longitude: 24.935105),
    CLLocationCoordinate2D(latitude: 60.169108, longitude: 24.936210),
    CLLocationCoordinate2D(latitude: 60.168355, longitude: 24.934869),
    CLLocationCoordinate2D(latitude: 60.167560, longitude: 24.932562),
    CLLocationCoordinate2D(latitude: 60.168254, longitude: 24.931532),
    CLLocationCoordinate2D(latitude: 60.169012, longitude: 24.930341),
    CLLocationCoordinate2D(latitude: 60.170085, longitude: 24.929569)
  ]

  weak var delegate: LocationManagerDelegate?
  private var timer: Timer?
  private var index = 0
  var currentLocation: CLLocationCoordinate2D?

  init() {
    currentLocation = locations[index]
    timer = Timer.scheduledTimer(
      withTimeInterval: TimeInterval(Configuration.locationChangeDuration),
      repeats: true)
    { [weak self] _ in
      guard let self = self else { return }
      index = (index == locations.count - 1) ? 0 : index + 1
      self.concurrentQueue.sync {
        let currentLocation = self.locations[self.index]
        self.currentLocation = currentLocation
        self.delegate?.didLocationChange(currentLocation)
      }
    }
  }

  deinit {
    timer?.invalidate()
    timer = nil
  }
}
