//
//  Helper.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-18.
//

import Foundation
import SwiftUI

// MARK: - ALERT MESSAGE
public func appAlert(title: String, message: String, buttonText: String) -> Alert {
    return Alert(title: Text(title), message: Text(message).font(.title2), dismissButton: .default(Text(buttonText)))
}

public struct DarkModeViewModifier: ViewModifier {
    @AppStorage ("isDarkMode") var isDarkMode: Bool = true
    
    public func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, isDarkMode ? .dark : .light)
            .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// MARK: - DATE FORMATTER
let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter
}()
