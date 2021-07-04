//
//  SettingsView.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-18.
//

import SwiftUI
import StoreKit

struct Settings: View {
    
    // MARK: - PROPERTIES
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage ("isPaidUser") var isPaidUser: Bool = false
    
    @AppStorage ("isOnboarding") var isOnboarding: Bool = true
    
    @AppStorage ("setReminder") var setReminder: Bool = false
    @AppStorage ("tickSoundOn") var tickSoundOn: Bool = false
    @AppStorage ("isSwooshAppearMP3") var isSwooshAppearMP3: Bool = false
    @AppStorage ("sortViewAppearSound") var sortViewAppearSound: Bool = false
    
    @AppStorage("applyThemesToLists") var applyThemesToLists: Bool = false
    
    @AppStorage ("autoCorrection") var autoCorrection: Bool = true
    
    // Theme colors
    @AppStorage ("topColorCode") var topColorCode: Int = 16777215
    @AppStorage ("bottomColorCode") var bottomColorCode: Int = 16777215
    @AppStorage ("topOpacity") var topOpacity: Double = 0.0
    @AppStorage ("bottomOpacity") var bottomOpacity: Double = 0.0
    
    @Binding var topColor: Color
    @Binding var bottomColor: Color
    
    // Priority Colors
    @AppStorage ("priority1ColorCode") var priority1ColorCode: Int = 9342611
    @AppStorage ("priority2ColorCode") var priority2ColorCode: Int = 31487
    @AppStorage ("priority3ColorCode") var priority3ColorCode: Int = 16726832
    
    @State var priority1Color: Color = Color.gray
    @State var priority2Color: Color = Color.green
    @State var priority3Color: Color = Color.red
    
    // MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            // MARK: - MAIN SCREEN
            VStack {

                // MARK: - 1.0 - SETTINGS
                NavigationView {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            
                            // MARK: - 1.1 - APP DESCRIPTION
                            GroupBox(label:
                                        SettingsLabel(labelText: appName, labelImage: "info.circle")
                                     ,
                                     content: {
                                        Divider().padding(.vertical, 4)
                                        VStack(spacing: 20) {
                                            HStack(alignment: .center, spacing: 10) {
                                                Image(appLogo)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .foregroundColor(Color.secondary)
                                                    .frame(width: 55, height: 55)
                                                    .cornerRadius(8)
                                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                                                .stroke()
                                                                .foregroundColor(Color.gray)
                                                                .frame(width: 56, height: 56)
                                                    )
                                                
                                                Text(appDescription)
                                                    .font(.footnote)
                                            }
                                        }
                                        
                                     })
                            
                            // MARK: - 1.2 - CUSTOMIZATION
                            GroupBox(label:
                                        SettingsLabel(labelText: "customization", labelImage: "paintbrush"),
                                     content: {
                                        
                                        // MARK: - 1.2.0 - SHOW WELCOME SCREEN
                                        Divider().padding(.vertical, 4)
                                        SettingsToggleRow(name: "Show Welcome Screen", isOn: $isOnboarding)
                                        
                                        // MARK: - 1.2.1 - TEXT AUTO CORRECTION
                                        Divider().padding(.vertical, 4)
                                        SettingsToggleRow(name: "Text Auto Correction", isOn: $autoCorrection)
                                        
                                        if isPaidUser {
                                            // MARK: - 1.2.2 - SOUND LINK
                                            Divider().padding(.vertical, 4)
                                            NavigationLink(
                                                destination:
                                                    ScrollView(.vertical, showsIndicators: false) {
                                                        VStack {
                                                            GroupBox(content: {
                                                                VStack {
                                                                    SettingsToggleRow(name: "Set Task Opened/Completed", isOn: $tickSoundOn)
                                                                    Divider().padding(.vertical, 4)
                                                                    SettingsToggleRow(name: "Set Reminder On/Off", isOn: $setReminder)
                                                                    Divider().padding(.vertical, 4)
                                                                    SettingsToggleRow(name: "Sort Screen Appear/Dissapear", isOn: $sortViewAppearSound)
                                                                    Divider().padding(.vertical, 4)
                                                                    SettingsToggleRow(name: "Deletion", isOn: $isSwooshAppearMP3)
                                                                }
                                                                .disabled(!isPaidUser)
                                                            }).padding(2)

                                                            Spacer()
                                                        }.navigationBarTitle("Sounds", displayMode: .inline)
                                                    }
                                                    .opacity(!isPaidUser ? 0.4 : 1.0)
                                                ,
                                                label: {
                                                    HStack {
                                                        Text("Sounds")
                                                            .fontWeight(.semibold)
                                                        Spacer()
                                                        Image(systemName: "chevron.right")
                                                    }.font(.body)
                                                    .foregroundColor(Color.gray)
                                                })
                                            Divider().padding(.vertical, 4)
                                            // MARK: - 1.2.3 - APPEARANCE LINK
                                            NavigationLink(
                                                destination:
                                                    ScrollView(.vertical, showsIndicators: false) {
                                                        VStack {
                                                            GroupBox(content: {
                                                                VStack {
                                                                    // MARK: - 1.2.3.1 - ADD THEME COLOURS TO LISTS
                                                                    SettingsToggleRow(name: "Apply Theme To Rows", isOn: $applyThemesToLists)
                                                                    Divider().padding(.vertical, 4)

                                                                    // MARK: - 1.2.3.2 - PRIORITY COLOURS
                                                                    NavigationLink(
                                                                        destination:
                                                                            ScrollView(.vertical, showsIndicators: false) {
                                                                                VStack {
                                                                                    // MARK: - 1.2.3.2.1 - PRIORITIES MENU BOX
                                                                                    GroupBox(
                                                                                        label:
                                                                                            Text("Priorities")
                                                                                            .fontWeight(.semibold)
                                                                                            .textCase(.uppercase)
                                                                                        ,
                                                                                        content: {
                                                                                            VStack {
                                                                                                Divider().padding(.vertical, 4)
                                                                                                SettingsColors(text: "Low", selectedColor: $priority1Color)
                                                                                                Divider().padding(.vertical, 4)
                                                                                                SettingsColors(text: "Normal", selectedColor: $priority2Color)
                                                                                                Divider().padding(.vertical, 4)
                                                                                                SettingsColors(text: "High", selectedColor: $priority3Color)
                                                                                            }
                                                                                            .disabled(!isPaidUser)
                                                                                        }

                                                                                    )

                                                                                    Spacer()
                                                                                }.padding(2)
                                                                            }
                                                                            .opacity(!isPaidUser ? 0.4 : 1.0)
                                                                        ,label: {
                                                                            SettingsNavigationLinkLabel(text: "Priority Colours")
                                                                        })
                                                                    Divider().padding(.vertical, 4)
                                                                    // MARK: - 1.2.3.3 - THEME COLOURS
                                                                    NavigationLink(
                                                                        destination:
                                                                            ScrollView(.vertical, showsIndicators: false) {
                                                                                VStack {
                                                                                    // MARK: - 1.2.3.3.1 - THEMES MENU BOX
                                                                                    GroupBox(
                                                                                        label:
                                                                                            Text("Theme Colours")
                                                                                            .fontWeight(.semibold)
                                                                                            .textCase(.uppercase)
                                                                                        ,
                                                                                        content: {
                                                                                            VStack {
                                                                                                Divider().padding(.vertical, 4)
                                                                                                SettingsColors(text: "Top", selectedColor: $topColor)
                                                                                                Slider(value: $topOpacity, in: 0...1, step: 0.1) {
                                                                                                    Text("Top Opacity")
                                                                                                }
                                                                                                Divider().padding(.vertical, 4)
                                                                                                SettingsColors(text: "Bottom", selectedColor: $bottomColor)
                                                                                                Slider(value: $bottomOpacity, in: 0...1, step: 0.1) {
                                                                                                    Text("Bottom Opacity")
                                                                                                }
                                                                                            }
                                                                                            .disabled(!isPaidUser)
                                                                                        })

                                                                                    GroupBox(
                                                                                        label:
                                                                                            Text("PREVIEW")
                                                                                        ,
                                                                                        content: {
                                                                                            Rectangle()
                                                                                                .fill(LinearGradient(gradient: Gradient(colors: [topColor.opacity(self.topOpacity), bottomColor.opacity(self.bottomOpacity)]), startPoint: .top, endPoint: .bottom))
                                                                                                .frame(height: geometry.size.height/3)
                                                                                                .cornerRadius(4)
                                                                                        })

                                                                                    Spacer()
                                                                                }.padding(2)
                                                                            }
                                                                            .opacity(!isPaidUser ? 0.4 : 1.0)

                                                                        ,label: {
                                                                            SettingsNavigationLinkLabel(text: "Theme Colours")
                                                                        })
                                                                }
                                                            }
                                                            ).padding(2)

                                                            Spacer()
                                                        }
                                                    }
                                                    .navigationBarTitle("Appearance", displayMode: .inline)
                                                ,
                                                label: {
                                                    SettingsNavigationLinkLabel(text: "Appearance")
                                                })
                                        }
                                     })
                            // MARK: - 1.3 - APPLICATION
                            GroupBox(label:
                                        SettingsLabel(labelText: "application", labelImage: "apps.iphone"),
                                     content: {
                                        SettingsRow(name: "Developer", content: developer)
                                        SettingsRow(name: "Compatibility", content: compatibility)
                                        SettingsRow(name: "Devices", content: devices)
                                        SettingsRow(name: "Version", content: appVersion)
                                     })
                            
                        }.padding(2)
                    }.navigationBarTitle(Text("Settings"), displayMode: .large)
                    .navigationBarItems(trailing:
                                            Button(action: {
                                                self.presentationMode.wrappedValue.dismiss()
                                            }, label: {
                                                Image(systemName: "xmark")
                                                    .font(.title2)
                                                    .foregroundColor(Color.secondary)
                                            })
                    )
                    
                }
                if !isPaidUser {
                    VStack {
                        UpgradeView()
                            .preferredColorScheme(.dark)
                    }
                }
                
                // MARK: ALL RIGHTS RESERVED
                Text("© \(allRightsReservedYear) Nuwan Sameera Hettige \nAll rights reserved")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.bottom, 8)
                    .foregroundColor(Color.secondary)
            }
            .onAppear() {
                
                priority1Color = Color.init(rawValue: priority1ColorCode) ?? Color(rawValue: 1677715)!
                priority2Color = Color.init(rawValue: priority2ColorCode) ?? Color(rawValue: 1677715)!
                priority3Color = Color.init(rawValue: priority3ColorCode) ?? Color(rawValue: 1677715)!
                
                topColor = Color.init(rawValue: topColorCode) ?? Color(rawValue: 1677715)!
                bottomColor = Color.init(rawValue: bottomColorCode) ?? Color(rawValue: 1677715)!
            }
            .onDisappear() {
                priority1ColorCode = priority1Color.rawValue
                priority2ColorCode = priority2Color.rawValue
                priority3ColorCode = priority3Color.rawValue
                
                topColorCode = topColor.rawValue
                bottomColorCode = bottomColor.rawValue
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(topColor: .constant(Color.blue), bottomColor: .constant(Color.blue))
            .preferredColorScheme(.dark)
    }
}
