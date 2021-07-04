//
//  Constant.swift
//  My ToDo List
//
//  Created by H.D.N.Sameera on 2021-03-13.
//

import Foundation

// MARK: - DATA

// APP INFORMATION
let appName: String = "Ready ToDo"
let appLogo: String = "Ready_ToDo"
let appDescription: String = "'\(appName)' is a very simple to-do app where you can store and manage tasks within different lists."
let developer: String = "Nuwan Sameera Hettige"
let compatibility: String = "Requires iOS 14.1 or later."
let devices: String = "iPhone, iPod touch and iPad."
let appVersion: String = "0.1.0"
let allRightsReservedYear: String = "2021"

// IN APP PURCHASE
// PRODUCTS
let productIDs = [
    "com.hdnsameera.MyToDoList"
]

// ADMOB
let admobUnitID: String = "ca-app-pub-6453148563036257/4613183142"

// ONBOARDING HEADER TEXTS
enum Page:String, CaseIterable {
    case title1 = "Manage Your Day"
    case title2 = "Be Prepared"
    case title3 = "Ready ToDo"
}

// ONBOARDING IMAGES AND DETAIL TEXTS
struct OnBoardingData {
    let imagesToDo = ["onBoardingImage_01", "onBoardingImage_02", "onBoardingImage_03"]
    let tipsTodo: [String] = [
        "Use your time wisely.",
        "Slow and steady wins the race.",
        "Keep it short and sweet.",
        "Put hard tasks first.",
        "Reward yourself after work.",
        "Collect tasks ahead of time.",
        "Each night schedule for tomorrow."
    ]
}

// FEATURES
let features = ["Screenshot_00" : "Task Notifications", "Screenshot_01" : "Opened Tasks Count", "Screenshot_02" : "Action Sounds", "Screenshot_03" : "Priority Colours", "Screenshot_04" : "Theme Colours"]

// TASKS STATUSES
enum Status: String, CaseIterable {
    case all = "All"
    case opened = "Opened"
    case completed = "Completed"
}

// TASKS PRIORITIES
enum Priority: String, CaseIterable {
    case low = "Low"
    case normal = "Normal"
    case high = "High"
}

// TASKS SORT BY
enum SortBy: String, CaseIterable {
    case task = "Title"
    case priority = "Priority"
    case dueOn = "Due Date"
    case timestamp = "Created Date"
}
