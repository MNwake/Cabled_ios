//
//  utils.swift
//  TheCWA
//
//  Created by Theo Koester on 3/1/24.
//

import Foundation

let WEBSOCKET_URL = "wss://koesterventures.com/contest/ws"
let BASE_URL = "https://koesterventures.com"


let divLabels: [ClosedRange<Int>: String] = [
    (-1...20): "Beginner",
    (21...40): "Novice",
    (41...60): "Intermediate",
    (61...80): "Advanced",
    (81...100): "Pro"
]

func calculateDivision(score: Int) -> String {
    for (range, label) in divLabels {
        if range.contains(score) {
            return label
        }
    }
    return "Unknown"
}

func calculateAge(birthDate: Date) -> Int {
    let calendar = Calendar.current
    let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
    return ageComponents.year ?? 0
}

func calculateAgeGroup(dob: Date) -> String {
    let age = calculateAge(birthDate: dob)
    switch age {
    case ..<11:
        return "Grom"
    case 11...16:
        return "Juniors"
    case 17...29:
        return "Adults"
    case 30...39:
        return "Masters"
    case 40...:
        return "Veterans"
    default:
        return "Unknown"
    }
}


func calculateBirthDate(age: Int) -> Date {
    let currentYear = Calendar.current.component(.year, from: Date())
    let birthYear = currentYear - age
    return Calendar.current.date(from: DateComponents(year: birthYear, month: 1, day: 1)) ?? Date()
}

import RegexBuilder
extension String {
    
    var isValidEmail: Bool {
        //        let emailFormat         = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        //        let emailPredicate      = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        //        return emailPredicate.evaluate(with: self)
        
        let emailRegex = Regex {
            OneOrMore {
                CharacterClass(
                    .anyOf("._%+-"),
                    ("A"..."Z"),
                    ("0"..."9"),
                    ("a"..."z")
                )
            }
            "@"
            OneOrMore {
                CharacterClass(
                    .anyOf("-"),
                    ("A"..."Z"),
                    ("a"..."z"),
                    ("0"..."9")
                )
            }
            "."
            Repeat(2...64) {
                CharacterClass(
                    ("A"..."Z"),
                    ("a"..."z")
                )
            }
        }
        
        return self.wholeMatch(of: emailRegex) !=  nil
    }
}

func divisionLabel(forValue value: Double) -> String {
    switch value {
    case ..<21:  // Everything below 21
        return "Beginner"
    case 21..<41:  // 21 (inclusive) to 41 (exclusive)
        return "Novice"
    case 41..<61:  // 41 (inclusive) to 61 (exclusive)
        return "Intermediate"
    case 61..<81:  // 61 (inclusive) to 81 (exclusive)
        return "Advanced"
    case 81...:  // Everything 81 and above
        return "Pro"
    default:
        return "Unknown"
    }
}

//func isValidForm() -> Bool {
//
//
//    guard !selectedRider.firstName.isEmpty && !selectedRider.lastName.isEmpty && !selectedRider.email.isEmpty else {
//        alertItem = AlertContext.alert(for: .invalidForm)
//        return false
//    }
//    guard selectedRider.email.isValidEmail else {
//        alertItem = AlertContext.alert(for: .invalidEmail)
//        return false
//    }
//    return true
//}

import SwiftUI
extension View {
    func asImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        UIGraphicsBeginImageContextWithOptions(controller.view.bounds.size, false, 0)
        controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000ff) / 255.0
        self.init(red: r, green: g, blue: b)
    }
    
    var hexString: String {
        let components = self.cgColor?.components
        let r: CGFloat = components?[0] ?? 0
        let g: CGFloat = components?[1] ?? 0
        let b: CGFloat = components?[2] ?? 0
        return String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}

enum BibColor: String, CaseIterable {
    case red, blue, green, orange, purple
    
    var color: Color {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return .green
        case .orange:
            return .orange
        case .purple:
            return .purple
        }
    }
    
    static func from(string: String) -> BibColor? {
        return BibColor(rawValue: string)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

enum ImageType {
    case profile
    case waiver
}

enum ScoreCategory: String {
    case creativity = "Creativity"
    case execution = "Execution"
    case difficulty = "Difficulty"
    case division = "Division"
    
    var color: Color {
        switch self {
        case .creativity:
            return Color.orange
        case .execution:
            return Color.green
        case .difficulty:
            return Color.red
        case.division:
            return Color(.label)
        }
    }
}
    
func get_experience_label(years_experience: Int) -> String {
        if years_experience < 0 {
            return "Invalid"
        } else if years_experience <= 1 {
            return "Newbies"
        } else if years_experience <= 3 {
            return "Rookies"
        } else if years_experience <= 5 {
            return "Seasoned"
        } else if years_experience < 10 {
            return "Experts"
        } else {
            return "Legends"
        }
    }
