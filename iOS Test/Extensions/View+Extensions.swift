// 
//  View+Extensions.swift
//  iOS Test
//
//  Created by Nazih Al Bach on 21.07.23.
//

import SwiftUI

struct ErrorAlert: ViewModifier {
	
  @Binding var error: VenuesError?
  var isShowingError: Binding<Bool> {
	Binding {
	  error != nil
	} set: { _ in
	  error = nil
	}
  }
	
  func body(content: Content) -> some View {
	content
	  .alert(isPresented: isShowingError, error: error) { _ in
	  } message: { error in
		  Text(error.errorMessage ?? "")
			  .opacity(error.errorMessage == nil ? 0 : 1)
	  }
  }
}

extension View {
  func errorAlert(_ error: Binding<VenuesError?>) -> some View {
	self.modifier(ErrorAlert(error: error))
  }
}
