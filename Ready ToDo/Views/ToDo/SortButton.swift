//
//  SortButton.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-01-22.
//

import SwiftUI

struct SortButton: View {

    // MARK: PROPERTIES
    @AppStorage ("currentSort") var currentSort: SortBy = .dueOn
    @AppStorage ("isAscending") var isAscending: Bool = false
    
    @Binding var sortDescriptor: [NSSortDescriptor]
    
    let iconButton: Bool
    let width, height: CGFloat
    let sortButton: SortBy
    
    // MARK: BODY
    var body: some View {
        
        // MARK: SORT BUTTON
        Button(action: {
            if iconButton {
                withAnimation {
                    // MARK:- IF BUTTON IS ICON
                    // Toggling the sorting by; either ascending or descending but the @AppStorage 'currentSort' does not change.
                    
                    isAscending.toggle()
                }
            } else {
                    // MARK:- IF BUTTON IS TEXT
                    // Parsing the selected sortBy enum (.item, .dueOn, .priority, .timestamp) to @AppStorage 'currentSort'.
                
                    currentSort = sortButton
            }
        
            // MARK: FILTER DATA FOR BOTH ICON AND TEXTS
            // Filter data
            switch sortButton {
            case .task:
                sortDescriptor.removeAll()
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.task, ascending: isAscending))
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.timestamp, ascending: isAscending))
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.priority, ascending: isAscending))
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.dueOn, ascending: isAscending))
                
            case .dueOn:
                sortDescriptor.removeAll()
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.dueOn, ascending: isAscending))
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.task, ascending: isAscending))
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.priority, ascending: isAscending))
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.dueOn, ascending: isAscending))
                
            case .priority:
                sortDescriptor.removeAll()
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.priority, ascending: isAscending))
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.task, ascending: isAscending))
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.timestamp, ascending: isAscending))
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.dueOn, ascending: isAscending))
                
            default:
                sortDescriptor.removeAll()
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.timestamp, ascending: isAscending))
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.task, ascending: isAscending))
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.priority, ascending: isAscending))
                sortDescriptor.append(NSSortDescriptor(keyPath: \ToDoEntity.dueOn, ascending: isAscending))
            }
            
        }, label: {
            
            // MARK:- IF ICON
            if iconButton {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.title2)
                    .foregroundColor(isAscending ? Color.blue : Color.orange)
                    .rotationEffect(Angle(degrees: isAscending ? 180 : 0))
            }
            // MARK:- IF TEXTS
            else {
                HStack {
                    Text(sortButton.rawValue)
                        .font(.callout)
                        .foregroundColor(sortButton == currentSort ? Color.blue : Color.orange)
                }.frame(width: width, height: height)
            }
        })
    }
}
