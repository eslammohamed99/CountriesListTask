//
//  CountryDetailUIView.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 27/03/2025.
//
import SwiftUI

struct CountryDetailUIView: View {
    @ObservedObject var viewModel: CountryDetailViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Navigation bar
                CustomNavigationBar {
                    viewModel.actionsSubject.send(.back)
                }
                
                // Main content
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Country flag image
                        AsyncImage(url: URL(string: viewModel.displayModel.image)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.3))
                        }
                        .frame(height: 200)
                        .cornerRadius(8)
                        .padding(.bottom, 8)
                        
                        // Country information
                        Group {
                            infoRow(title: "Country Name:", value: viewModel.displayModel.name)
                            infoRow(title: "Capital:", value: viewModel.displayModel.capitalName)
                            infoRow(title: "Currency:", value: viewModel.displayModel.curency?.name ?? "Not available")
                            
                            // Add location information if available
                            if let location = viewModel.displayModel.location {
                                infoRow(title: "Coordinates:", value: "\(location.coordinate.latitude.formatted()), \(location.coordinate.longitude.formatted())")
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 30) // Adjust based on your navigation bar height
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    // Helper function for consistent info rows
    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
        }
        .padding(.vertical, 4)
    }
}
