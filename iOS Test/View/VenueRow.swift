// 
//  VenueRow.swift
//  iOS Test
//
//  Created by Nazih Al Bach on 21.07.23.
//

import SwiftUI
import SDWebImageSwiftUI

struct VenueRow: View {

	@StateObject var viewModel: VenueViewModel
  let onToggleFavorite: () -> Void
  @State private var imageLoaded = false

	var body: some View {
		VStack {
			VStack(alignment: .leading, spacing: 8) {
        ZStack(alignment: .topTrailing) {
          WebImage(url: URL(string: viewModel.imageURL))
            .onSuccess(perform: { _, _, _ in
              imageLoaded = true
            })
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .opacity(imageLoaded ? 1 : 0)
            .animation(.easeInOut(duration: 0.2), value: imageLoaded)

          LinearGradient(
            gradient: .init(colors: [
              Color.black.opacity(0.3),
              Color.clear
            ]),
            startPoint: .top,
            endPoint: .center
          )
          .frame(height: 200)
            .cornerRadius(10)
            .shadow(radius: 5)

          Button {
            withAnimation {
              onToggleFavorite()
            }
          } label: {
            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
              .resizable()
              .scaledToFit()
              .foregroundColor(.white)
              .frame(width: 24, height: 24)
              .transition(.scale.animation(.easeInOut(duration: 0.2)))
          }
          .padding()
        }

        VStack(alignment: .leading, spacing: 4) {
          Text(viewModel.name)
            .fontWeight(.bold)

          if let description = viewModel.description {
            Text(description)
              .font(.system(size: 14, weight: .regular))
              .multilineTextAlignment(.leading)
          }
				}
				.padding(.horizontal)
				.padding(.bottom)
			}
			.background(Color.white)
			.foregroundColor(.black)
			.cornerRadius(10)
		}
    .padding(.bottom)
	}
}

struct VenueRow_Previews: PreviewProvider {
	static var previews: some View {
		VenueRow(
      viewModel: VenueViewModel.default,
      onToggleFavorite: {}
	  )
		.previewLayout(.fixed(width: 375, height: 60))
		.padding()
	}
}
