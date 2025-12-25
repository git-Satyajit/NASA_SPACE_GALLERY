//
//  HomeView.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 25/12/25.
//


import SwiftUI

@MainActor
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    var validDateRange: ClosedRange<Date> {
            let minDate = Calendar.current.date(from: DateComponents(year: 1995, month: 6, day: 16))!
            let maxDate = Date()
            return minDate...maxDate
        }
    
    var body: some View {
        NavigationView {
            VStack {
                
                DatePicker("Select Date",
                           selection: $viewModel.selectedDate,
                           in: validDateRange, 
                           displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()
                .onChange(of: viewModel.selectedDate) { _, newDate in
                    viewModel.updateDate(to: newDate)
                                    }
                
            
                Group {
                    switch viewModel.state {
                    case .idle:
                        Color.clear.onAppear { viewModel.loadTodaysPhoto() }
                        
                    case .loading:
                        ProgressView("Fetching from NASA...")
                            .scaleEffect(1.5)
                        
                    case .success(let apod):
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                MediaView(apod: apod)
                                    
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                Text(apod.title)
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.primary)
                                HStack {
                                    Text(apod.date)
                                    Spacer()
                                    if let copyright = apod.copyright {
                                        Text("© \(copyright)")
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.secondary)
                                Text(apod.explanation)
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                        }
                        
                    case .error(let message):
                        VStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            Text("Oops!")
                                .font(.headline)
                            Text(message)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Button("Try Again") {
                                viewModel.loadTodaysPhoto()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("NASA Picture")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

