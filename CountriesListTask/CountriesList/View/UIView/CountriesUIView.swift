//
//  CountriesUIView.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 25/03/2025.
//

import SwiftUI
import Kingfisher

struct CountriesListUIView: View {
    @ObservedObject var viewModel: CountriesListViewModel
    @State private var showCountrySheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Selected Countries
            VStack(alignment: .leading, spacing: 5) {
                if viewModel.selectedCountries.isEmpty {
                    Button(action: {
                        showCountrySheet = true
                    }) {
                        Text("Select Countries")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                } else {
                    // Selected countries list
                    ForEach(viewModel.selectedCountries, id: \.id) { item in
                        Button(action: {
                            viewModel.actionsSubject.send(.gotoDetail(info: item))
                        }) {
                            HStack {
                                if let imageURL = URL(string: item.image) {
                                    KFImage.url(imageURL)
                                        .placeholder {
                                            ProgressView()
                                        }
                                        .resizable()
                                        .frame(width: 30, height: 15)
                                }
                                Text(item.name)
                                    .padding(.vertical, 8)
                                
                                Spacer()
                                Button(action: {
                                    viewModel.toggleCountrySelection(item)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    // Add more button
                    if viewModel.addMore {
                        Button(action: {
                            showCountrySheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add More Countries")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
            }
            .padding()
            Spacer()
        }
        .sheet(isPresented: $showCountrySheet) {
            CountrySelectionSheet(
                viewModel: viewModel,
                isPresented: $showCountrySheet
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .loadingOverlay(isLoading: viewModel.isLoading)
        .onAppear { Task { viewModel.viewDidLoad() } }
    }
}

// Country Selection Sheet View
struct CountrySelectionSheet: View {
    @ObservedObject var viewModel: CountriesListViewModel
    @Binding var isPresented: Bool
    @State private var searchText = ""
    var body: some View {
        List {
            Section(header:
                        VStack {
                HStack {
                    Spacer()
                    Text("Search Country")
                        .font(.headline)
                    Spacer()
                    
                    Button {
                        isPresented = false
                    } label: {
                        Text("Done")
                    }
                }
                TextField("Search here...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 48)
                    .padding(.vertical, 8)
                    .autocorrectionDisabled(true)
//                    .onChange(of: searchText) { oldValue, newValue in
//                        viewModel.filterCountries(searchQuery: newValue)
//                    }
            }.padding(.vertical, 8)
            ) {
                ForEach(viewModel.filterCountries(searchQuery: searchText), id: \.id) { item in
                    Button {
                        viewModel.toggleCountrySelection(item)
                    } label: {
                        HStack {
                            if let imageURL = URL(string: item.image) {
                                KFImage.url(imageURL)
                                    .placeholder {
                                        ProgressView()
                                    }
                                    .resizable()
                                    .frame(width: 30, height: 15)
                            }
                            Text(item.name)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if viewModel.isCountrySelected(item) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .listStyle(PlainListStyle())
        .alert(isPresented: $viewModel.showMaxLimitAlert) {
            Alert(
                title: Text("Maximum Countries Reached"),
                message: Text("You can select a maximum of 5 countries."),
                dismissButton: .default(Text("OK"))
            )
        }
        
    }
}
