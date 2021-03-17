//
//  DateUtils.swift
//  TwoNotes
//
//  Created by Terry Lee on 3/16/21.
//

import Foundation

/*
 Create a util class
 Create a singleton (just a shared variable with private init())
 */
class DateUtils {
    static let shared = DateUtils()
    private let notesListDateFormatter = DateFormatter()    // Date formatter for notes list screen
    private let noteDetailDateFormatter = DateFormatter()   // Date formatter for notes detail
    
    init() {
        setup()
    }
    
    private func setup() {
        // Date format ex. Wednesday 12:00 PM
        noteDetailDateFormatter.dateFormat = "h:mm a"
        
        // Date format ex. 12/22/22
        notesListDateFormatter.dateFormat = "MM/dd/yyyy"
        notesListDateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale?
    }
    
    func string(from date: Date) -> String {
        let weekday = Calendar.current.component(.weekday, from: date)
        let dateInString = noteDetailDateFormatter.string(from: date)
        return Calendar.current.weekdaySymbols[weekday-1] + " \(dateInString)"
    }
    
    func noteString(from date: Date) -> String {
        let weekday = Calendar.current.component(.weekday, from: date)
        let dateInString = notesListDateFormatter.string(from: date)
        return Calendar.current.weekdaySymbols[weekday-1] + " \(dateInString)"
    }

}
