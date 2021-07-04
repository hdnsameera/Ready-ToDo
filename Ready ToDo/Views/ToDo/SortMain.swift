//
//  Sort.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-21.
//

import SwiftUI

struct SortMain: View {
    
    // Theme colors
    @AppStorage ("topColorCode") var topColorCode: Int = 16777215
    @AppStorage ("bottomColorCode") var bottomColorCode: Int = 16777215
    @AppStorage ("topOpacity") var topOpacity: Double = 0.0
    @AppStorage ("bottomOpacity") var bottomOpacity: Double = 0.0
    
    @AppStorage("applyThemesToLists") var applyThemesToLists: Bool = false
    
    @AppStorage ("currentSort") var currentSort: SortBy = .dueOn
    @AppStorage ("sortViewAppearSound") var sortViewAppearSound: Bool = false
    
    @State var topColor: Color = Color.blue
    @State var bottomColor: Color = Color.blue
    
    @Binding var showPopUp: Bool
    @Binding var sortDescriptor: [NSSortDescriptor]
    
    let width, height: CGFloat
    
    var body: some View {
        VStack {
            // MARK:- SORT VIEW BOX
            GroupBox(
                label:
                    VStack(alignment: .leading) {
                        HStack {
                            // MARK:- SORT BUTTON ICON
                            SortButton(sortDescriptor: $sortDescriptor, iconButton: true, width: 20, height: 20, sortButton: currentSort)
                            
                            Spacer()
                            
                            // MARK:- CLOSE BUTTON
                            Button(action: {
                                withAnimation {
                                    self.showPopUp = false
                                }
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(Color.secondary)
                            })
                        }.frame(width: width, height: height/4)
                    }
                ,
                
                content: {
                    VStack(alignment: .center, spacing: 8) {
                        // MARK:- LOOPING SORT CASES
                        ForEach(SortBy.allCases, id:\.self) { sortButton in
                            Divider()
                            HStack {
                                // MARK:- SORT BUTTON TEXTS
                                SortButton(sortDescriptor: $sortDescriptor, iconButton: false, width: width, height: height/6, sortButton: sortButton)
                                    .background(applyThemesToLists ? LinearGradient(gradient: Gradient(colors: [topColor.opacity(self.topOpacity), bottomColor.opacity(self.bottomOpacity)]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [Color.clear]), startPoint: .top, endPoint: .bottom))
                                    .cornerRadius(8)
                            }
                        }
                    }.font(.caption)
                    .padding(.top, 4)
                }).frame(width: width, height: height)
        }
        .transition(.slide)
        .onAppear() {
            
            topColor    = Color.init(rawValue: topColorCode) ?? Color(rawValue: 1677715)!
            bottomColor = Color.init(rawValue: bottomColorCode) ?? Color(rawValue: 1677715)!
            
            if sortViewAppearSound {
                playSound(sound: "SwooshAppear", type: "mp3")
            }
        }
        .onDisappear() {
            if sortViewAppearSound {
                playSound(sound: "SwooshDisappear", type: "mp3")
            }
        }
        .opacity(0.9)
    }
}
