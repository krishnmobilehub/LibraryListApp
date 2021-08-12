//
//  Constants.swift
//  Hakbah
//

import Foundation
struct DefaultsKey {
    static let cartData = "CartData"
}

struct Alert {
    static let title = "Hakbah"
    static let comingSoon = "Coming soon.."
    static let ok = "OK"
    static let error = "Error"
}

public enum StoreType: String, Codable {
    case store = "store"
    case online = "online"
}

public enum WeekDayType: String {
    case sun = "sun"
    case mon = "mon"
    case tue = "tue"
    case wed = "wed"
    case thu = "thu"
    case fri = "fri"
    case sat = "sat"
}
