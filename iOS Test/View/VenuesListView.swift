// 
//  VenuesListView.swift
//  iOS Test
//
//  Created by Nazih Al Bach on 21.07.23.
//

import SwiftUI

struct VenuesListView: View {
  
	@StateObject var viewModel: VenuesListViewModel

	var body: some View {
		NavigationView {
			if viewModel.isLoading && viewModel.venues.isEmpty {
				ZStack(alignment: .center) {
					ActivityIndicator(
						isAnimating: .constant(true),
						style: .medium
					)
				}
			} else {
        if viewModel.venues.isEmpty {
          Text("There are no venues near your current location.".localized)
            .padding()
        } else {
          list
            .navigationBarTitle("Venues".localized)
        }
      }
		}
		.errorAlert($viewModel.error)
		.onAppear {
      viewModel.viewDidAppear()
		}
	}
  
	private var list: some View {
		List {
			ForEach(viewModel.venues) { venue in
				VenueRow(
          viewModel: venue,
          onToggleFavorite: {
            viewModel.toggleFavoriteStatus(
              for: venue.venueId
            )
          }
        )
			}
			.listRowBackground(Color.clear)
			.listRowSeparator(.hidden)
			.listRowInsets(EdgeInsets())
		}
	}
}

struct VenuesListView_Previews: PreviewProvider {
	static var previews: some View {
		VenuesListView(
      viewModel: VenuesListViewModel(
				service: VenuesService(
					session: URLSession.shared,
					decoder: JSONDecoder()
				),
        locationManager: LocationManager()
			)
		)
	}
}
