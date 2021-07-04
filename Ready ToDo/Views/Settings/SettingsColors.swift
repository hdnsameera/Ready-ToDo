//
//  TestView.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-26.
//

import SwiftUI

struct SettingsColors: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let colorSet: [Color] = [
        Color.gray, Color.blue, Color.purple, Color.red, Color.green, Color.orange
    ]
    
    let text: String
    @Binding var selectedColor: Color
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(text)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(colorScheme == .dark ? (self.selectedColor == Color.black ? Color.white : self.selectedColor) : (self.selectedColor == Color.white ? Color.black : self.selectedColor))
                Spacer()
   
            }
            HStack {
                ColorButton(text: text, color: colorScheme == .dark ? Color.white : Color.black, selectedColor: $selectedColor)
                
                    ForEach(colorSet, id:\.self) { color in
                        ColorButton(text: text, color: color, selectedColor: $selectedColor)
                    }
            }
            
        }
    }
}

struct ColorButton: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let text: String
    let color: Color
    @Binding var selectedColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 33, height: 33)
                .foregroundColor(color)
            
            Button(action: {
                    self.selectedColor = color
            }, label: {
                ZStack {
                    
                    Circle()
                        .frame(width: 22, height: 22)
                        .foregroundColor(color)
                        .shadow(color: Color.white.opacity(0.2), radius: 1, x: 1, y: 1)
                        .shadow(color: Color.black, radius: 1, x: -1, y: -1)
                }
                
            })
            
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsColors(text: "Normal", selectedColor: .constant(Color.orange)).preferredColorScheme(.light)
    }
}
