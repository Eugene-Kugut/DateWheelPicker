//
//  BirthdayWheelPicker.swift
//  DateWheelPicker
//
//  Created by Evgeniy Kugut on 23.10.2024.
//

import SwiftUI
import CustomWheelPicker

public struct BirthdayWheelPicker: View {

    private let leapYear = 2024

    @Binding private var birthdayDate: BirthdayDate

    @State private var year: Int?
    private let years: [Int?]

    @State private var month: Int
    private let months: [Int]

    @State private var day: Int
    @State private var days: [Int]
    private let config: CustomWheelPickerConfig

    init(birthdayDate: Binding<BirthdayDate>, countYears: Int = 120, config: CustomWheelPickerConfig = .defaultConfig) {
        self.config = config
        self._birthdayDate = birthdayDate

        let startYear = Date().year
        var years: [Int?] = Array(startYear - countYears...startYear)
        years.append(nil)
        self.years = years.reversed()

        self.months = Array(1...12)

        switch birthdayDate.wrappedValue {
        case .monthAndDay(let month, let day):
            let lastDay = Date.lastDay(forYear: leapYear, month: month) ?? 1
            self.year = nil
            self.month = month
            self.day = min(day, lastDay)
            self.days = Array(1...lastDay)
        case .yearMonthAndDay(let year, let month, let day):
            let lastDay = Date.lastDay(forYear: year, month: month) ?? 1
            self.year = year
            self.month = month
            self.day = min(day, lastDay)
            self.days = Array(1...lastDay)
        }
    }

    private func updateBirthdayDate() {
        if let year = year {
            birthdayDate = .yearMonthAndDay(year: year, month: month, day: day)
        } else {
            birthdayDate = .monthAndDay(month: month, day: day)
        }
    }

    private func updateMonthDays() {
        if let lastDay = Date.lastDay(forYear: year ?? leapYear, month: month) {
            let allDays = Array(1...lastDay)
            days.removeAll()
            days.append(contentsOf: allDays)
            if !allDays.contains(day), let lastDay = allDays.last {
                day = lastDay
            }
        }
    }

    public var body: some View {
        HStack(spacing: 0) {
            getUIControl(by: 0, year: $year, years: years, month: $month, months: months, day: $day, days: $days)
            Divider()
                .frame(height: config.height - config.rowHeight)
                .opacity(config.showDivider ? 1 : 0)
            getUIControl(by: 1, year: $year, years: years, month: $month, months: months, day: $day, days: $days)
            Divider()
                .frame(height: config.height - config.rowHeight)
                .opacity(config.showDivider ? 1 : 0)
            getUIControl(by: 2, year: $year, years: years, month: $month, months: months, day: $day, days: $days)
        }
        .background(SelectedPositionBackground(config: config))
        .padding(.horizontal)
        .onChange(of: day, { _, _ in
            updateBirthdayDate()
        })
        .onChange(of: month) { _, _ in
            updateMonthDays()
            updateBirthdayDate()
        }
        .onChange(of: year) { _, _ in
            updateMonthDays()
            updateBirthdayDate()
        }
        .onAppear(perform: {
            updateMonthDays()
            updateBirthdayDate()
        })
    }
}

private extension BirthdayWheelPicker {

    @ViewBuilder private func yearUIControl(year: Binding<Int?>, years: [Int?]) -> some View {
        CustomFiniteWheelPicker(selection: $year, items: years) { value in
            if let year = value {
                if let value = year {
                    Text(String(value))
                        .fontWeight(config.fontWeight)
                        .font(config.font)
                } else {
                    Text("- - - -")
                        .fontWeight(config.fontWeight)
                        .font(config.font)
                }
            } else {
                Text("")
            }
        }
        .frame(width: 100)
    }

    @ViewBuilder private func monthUIControl(month: Binding<Int>, months: [Int]) -> some View {
        CustomCircularWheelPicker(selection: $month, items: months) { value in
            if let month = value {
                Text(DateFormatter().monthSymbols[month - 1])
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(config.fontWeight)
                    .font(config.font)
            } else {
                Text("")
            }

        }.padding(.leading)
    }

    @ViewBuilder private func dayUIControl(day: Binding<Int>, days: Binding<[Int]>) -> some View {
        CustomCircularWheelPicker(selection: $day, items: days.wrappedValue) { value in
            if let day = value {
                Text(String(day))
                .fontWeight(config.fontWeight)
                .font(config.font)
            } else {
                Text("")
            }
        }
        .frame(width: 80)
        .id(days.count)
    }

    @ViewBuilder private func getUIControl(by index: Int,
                                           year: Binding<Int?>,
                                           years: [Int?],
                                           month: Binding<Int>,
                                           months: [Int],
                                           day: Binding<Int>,
                                           days: Binding<[Int]>
    ) -> some View {
        let yearIndex = CustomDateComponent.year.dateComponentOrderForCurrentLocale
        let monthIndex = CustomDateComponent.month.dateComponentOrderForCurrentLocale

        if index == yearIndex {
            yearUIControl(year: year, years: years)
        } else if index == monthIndex {
            monthUIControl(month: month, months: months)
        } else {
            dayUIControl(day: day, days: $days)
        }
    }

}

#Preview {
    @Previewable @State var birthdayDate: BirthdayDate = .monthAndDay(month: 4, day: 31)
    BirthdayWheelPicker(birthdayDate: $birthdayDate)
}
