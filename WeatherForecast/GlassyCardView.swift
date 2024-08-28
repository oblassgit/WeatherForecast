//
//  GlassyCardView.swift
//  WeatherForecast
//
//  Created by Oliver Blass on 21.08.24.
//

import SwiftUI

struct GlassyCardView: View {
    
    let viewDescription: String
    let iconName: String
    let smallIconName: String
    let bigText: String
    let smallText: String
    let showSmall: Bool
    let unit: String
    
    var body: some View {
            VStack {
                HStack {
                    Image(systemName: iconName)
                        .font(.subheadline)
                    Text(viewDescription)
                        .font(.subheadline.smallCaps())
                    Spacer()
                }.foregroundStyle(Color.secondary)
                Divider()
                Spacer()
                
                if showSmall {
                    HStack {
                        Image(systemName: smallIconName)
                        Text(smallText)
                        Spacer()
                    }
                }
                
                
                HStack {
                    Text(bigText)
                        .font(.largeTitle)
                    
                    Text(unit)
                        .font(.title2)
                    Spacer()
                }
                
            }
                .frame(minHeight: 50, maxHeight: 100)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .opacity(0.25)
                        .shadow(radius: 10)
                }
            
        }

    
}

#Preview {
    GlassyCardView(viewDescription: "description", iconName: "pencil", smallIconName: "safari.fill", bigText: "BIG", smallText: "smol", showSmall: true, unit: "unit")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
}
