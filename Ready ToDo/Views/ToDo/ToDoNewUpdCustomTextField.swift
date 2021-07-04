//
//  CustomTextField.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-24.
//

import SwiftUI

struct ToDoNewUpdCustomTextField: View {
    
    // MARK: - PROPERTIES
    @AppStorage ("autoCorrection") var autoCorrection: Bool = true
    
    let isActive: Bool
    let text: String
    @Binding var showExtension: Bool
    @Binding var textExtended: String
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Spacer()
            TextField(text, text: self.$textExtended)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(isActive ? Color.primary : Color.gray)
                .keyboardType(.default)
                .disabled(!isActive)
                .disableAutocorrection(!autoCorrection)
            
            // MARK: - EXTENTION BUTTON >
            IconButtonView(icon: "chevron.forward", width: 23, height: 23, bindingBool: $showExtension)
  
            NavigationLink("", destination: ToDoNewUpdTextExtension(text: $textExtended, isActive: isActive, header: text), isActive: $showExtension)
            
            Spacer()
        }
    }
}

struct ToDoNewUpdCustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ToDoNewUpdCustomTextField(autoCorrection: true, isActive: true, text: "Test", showExtension: .constant(true), textExtended: .constant("Text"))
        }
    }
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
