//
//  HomeView.swift
//  NASA_SPACE_GALLERY
//
//  Created by Satyajit Bhol on 25/12/25.
//


import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    let minDate = Calendar.current.date(from: DateComponents(year: 1995, month: 6, day: 16))!
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 0) {
                HStack {
                    Text("Pick Date:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    DatePicker("", selection: $viewModel.selectedDate, in: minDate...Date(), displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: viewModel.selectedDate) { _, newDate in
                            viewModel.loadDate(newDate)
                        }
                    
                    Spacer()
                    
                    Button(action: { viewModel.loadRecentPhotos() }) {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(Color("BrandColor"))
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                
                // 2. Content Grid (This is the ONLY ScrollView)
                ScrollView {
                    switch viewModel.state {
                    case .idle, .loading:
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(0..<6, id: \.self) { _ in SkeletonView().frame(height: 200) }
                        }
                        .padding()
                        
                    case .success(let apods):
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(apods) { apod in
                                NavigationLink(destination: DetailView(apod: apod)) {
                                    APODGridItem(apod: apod)
                                }
                            }
                        }
                        .padding()
                        
                    case .error(let msg):
                        Text(msg).foregroundColor(.red).padding()
                    }
                }
            }
            .navigationTitle("NASA Gallery 🌌")
            .onAppear {
                // Only load if empty (Optional optimization for first launch)
                if case .idle = viewModel.state {
                    viewModel.loadRecentPhotos()
                }
            }
        }
    }
}
