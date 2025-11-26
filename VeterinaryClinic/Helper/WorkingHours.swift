//
//  WorkingHours.swift
//  VeterinaryClinic
//
//  Created by Apple on 26/11/25.
//

import Foundation

func isWithinWorkHours(_ workHours: String) -> Bool {
    // Example: "M-F 9:00 - 18:00"
    // Extract days and time
    let components = workHours.components(separatedBy: " ")
    guard components.count >= 3 else { return false }

    let dayRange = components[0]        // "M-F"
    let timeStart = components[1]       // "9:00"
    let timeEnd = components[3]         // "18:00"

    // Current day/time
    let now = Date()
    let calendar = Calendar.current
    let currentHour = calendar.component(.hour, from: now)
    let currentMinute = calendar.component(.minute, from: now)
    let currentWeekday = calendar.component(.weekday, from: now) // 1=Sun, 2=Mon,...

    // Workday range (M-F)
    let mappedDays: [String: Int] = [
        "M": 2, "T": 3, "W": 4, "Th": 5, "F": 6, "Sa": 7, "Su": 1
    ]

    let dayParts = dayRange.split(separator: "-")
    guard dayParts.count == 2,
          let startDay = mappedDays[String(dayParts[0])],
          let endDay = mappedDays[String(dayParts[1])] else { return false }

    let isDayInRange = (startDay <= currentWeekday && currentWeekday <= endDay)

    // Time comparison
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"

    guard let startDate = formatter.date(from: timeStart),
          let endDate = formatter.date(from: timeEnd) else { return false }

    // Build today's equivalent times
    let nowInMinutes = currentHour * 60 + currentMinute

    let startComponents = calendar.dateComponents([.hour, .minute], from: startDate)
    let endComponents = calendar.dateComponents([.hour, .minute], from: endDate)

    let startMinutes = (startComponents.hour ?? 0) * 60 + (startComponents.minute ?? 0)
    let endMinutes = (endComponents.hour ?? 0) * 60 + (endComponents.minute ?? 0)

    let isTimeInRange = (startMinutes <= nowInMinutes && nowInMinutes <= endMinutes)

    return isDayInRange && isTimeInRange
}

//constants msg

enum ConstantsMSG {
    static let withinWorkHours = "Thank you for getting in touch with us. We’ll get back to you as soon as possible"
    static let outsideWorkHours = "Work hours has ended. Please contact us again on the next work day"
}
