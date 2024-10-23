//
//  File.swift
//  DateWheelPicker
//
//  Created by Evgeniy Kugut on 24.10.2024.
//

import Foundation

enum CustomDateComponent: Equatable {
    case year
    case month
    case day
}

extension CustomDateComponent {

    var dateComponentOrderForCurrentLocale: Int? {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short

        guard let dateFormat = formatter.dateFormat else {
            return nil
        }

        /* Приводим формат даты в упрощённый вид для анализа. "DMY"|"DYM"|"YMD"|"YDM"|"MDY"
           Результат строка из 3 символов указывающих на компоненты даты в верхнем регистре, в порядке следования компонентов согласно формату даты в текущей локали.
        */
        let dateComponentOrder = dateFormat.replacingOccurrences(of: "y", with: "Y")
                                           .replacingOccurrences(of: "M", with: "M")
                                           .replacingOccurrences(of: "d", with: "D")
                                           .replacingOccurrences(of: "YY", with: "Y")
                                           .replacingOccurrences(of: "MM", with: "M")
                                           .replacingOccurrences(of: "DD", with: "D")
                                           .filter { character in
                                               return ["Y", "M", "D"].contains(character)
                                           }
        switch self {
        case .year:
            return dateComponentOrder.firstIndex(of: "Y")?.utf16Offset(in: dateComponentOrder)
        case .month:
            return dateComponentOrder.firstIndex(of: "M")?.utf16Offset(in: dateComponentOrder)
        case .day:
            return dateComponentOrder.firstIndex(of: "D")?.utf16Offset(in: dateComponentOrder)
        }
    }
}
