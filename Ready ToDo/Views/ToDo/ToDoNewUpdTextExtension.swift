//
//  Notes.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-22.
//

import SwiftUI

struct ToDoNewUpdTextExtension: View {
    
    // MARK: - PROPERTIES
    @AppStorage ("autoCorrection") var autoCorrection: Bool = true
    
    // Theme colors
    @AppStorage ("topColorCode") var topColorCode: Int = 16777215
    @AppStorage ("bottomColorCode") var bottomColorCode: Int = 16777215
    @AppStorage ("topOpacity") var topOpacity: Double = 0.0
    @AppStorage ("bottomOpacity") var bottomOpacity: Double = 0.0
    
    @State var topColor: Color = Color.blue
    @State var bottomColor: Color = Color.blue
    
    @Binding var text: String
    
    let isActive: Bool
    let header: String
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .center) {
                    HStack() {
                        Spacer()
                        // MARK: - HEADER TEXT
                        Text(header)
                            .font(.title2)
                            .foregroundColor(Color.secondary)
                        Spacer()
                    }.padding()
                    
                    VStack {
                            ZStack {
                                // MARK: - TEXT EDITOR BACKGROUND LINE RECTANGLE
                                Rectangle()
                                    .frame(width: geometry.size.width - geometry.size.width/20, height: geometry.size.height)
                                    .foregroundColor(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                
                                // MARK: - TEXT EDITOR
                                if isActive {
                                    VStack {
                                        ScrollView {
                                            TextEditor(text: $text)
                                            .foregroundColor(!isActive ? Color.gray : Color.primary)
                                                .frame(width: geometry.size.width - geometry.size.width/15, height: geometry.size.height)
                                                .frame(maxHeight: .infinity)
                                            .cornerRadius(10)
                                                .disableAutocorrection(!autoCorrection)
                                    }
                                    }.frame(width: geometry.size.width - geometry.size.width/15, height:
                                                geometry.size.height - geometry.size.height/50
                                               
                                    )
                                    .frame(maxHeight: .infinity)
                                } else {
                                    VStack {
                                        ScrollView(.vertical, showsIndicators: true) {
                                            HStack() {
                                                Text(text)
                                                    .lineLimit(nil)
                                                    .foregroundColor(Color.gray)
                                                    .frame(maxHeight: .infinity)
                                                    .cornerRadius(10)
                                                    .padding(.top, 10)
                                                Spacer()
                                            }
                                        }
                                        Spacer()
                                    }.frame(width: geometry.size.width - geometry.size.width/15, height:
                                                geometry.size.height - geometry.size.height/50
                                    )
                                }
                            }
                    }
                }.padding(.top, geometry.size.height/10)
                .shadow(radius: 10)
            }.onAppear() {
                topColor    = Color.init(rawValue: topColorCode) ?? Color(rawValue: 1677715)!
                bottomColor = Color.init(rawValue: bottomColorCode) ?? Color(rawValue: 1677715)!
            }
            .background(LinearGradient(gradient: Gradient(colors: [topColor.opacity(self.topOpacity), bottomColor.opacity(self.bottomOpacity)]), startPoint: .top, endPoint: .bottom))
            .edgesIgnoringSafeArea(.all)
            
        }
    }
}

struct ToDoNewUpdTextExtension_Previews: PreviewProvider {
    static var previews: some View {
        ToDoNewUpdTextExtension(text: .constant("My notes My notes My notes My notes My notes My notes My notes My notes My notes My notes My notes My notes My notes f"), isActive: false, header: "Notes").preferredColorScheme(.dark)
    }
}
