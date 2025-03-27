//
//  CustomNavigation.swift
//  CountriesListTask
//
//  Created by Eslam Mohamed on 27/03/2025.
//

import SwiftUI


struct CustomNavigationBar: View {
    let onBackTap: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBackTap) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 40)
                        .shadow(radius: 2)
                    
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .frame(width: 20, height: 15)
                        .foregroundStyle(.black)
                }
            }
            .padding(.leading, 16)
            
            Spacer()
        }
        .frame(height: 90)
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
    }
}
