//
//  File.swift
//  DateWheelPicker
//
//  Created by Evgeniy Kugut on 24.10.2024.
//

import SwiftUI
import CustomWheelPicker

public enum TimerFormat {
    case hours24
    case hours12
}

public struct TimerWheelPicker: View {

    enum AmPm {
        case am
        case pm

        var description: String {
            switch self {
            case .am:
                return "AM"
            case .pm:
                return "PM"
            }
        }
    }

    @Binding var date: Date

    @State private var hour: Int
    @State private var minute: Int
    private let hours: [Int]
    private let minutes = Array(0..<60)
    private let format: TimerFormat
    private let amPm: [AmPm] = [.am, .pm]
    @State private var amOrPm: AmPm
    private let config: CustomWheelPickerConfig

    init(date: Binding<Date>, format: TimerFormat, config: CustomWheelPickerConfig = .defaultConfig) {
        self.config = config
        self.format = format
        switch format {
        case .hours24:
            hours = Array(0..<24)
        case .hours12:
            hours = Array(0..<12)
        }
        _date = date
        let hour = date.wrappedValue.hour
        let minute = date.wrappedValue.minute
        amOrPm = hour < 12 ? .am : .pm
        switch format {
        case .hours12:
            if hour < 12 {
                self.hour = hour
            } else {
                self.hour = hour - 12
            }
        case .hours24:
            self.hour = hour
        }
        self.minute = minute
    }

    private func updateTime() {
        let year = date.year
        let month = date.month
        let day = date.day
        let second = date.second

        let hour: Int
        switch format {
        case .hours12:
            switch amOrPm {
            case .am:
                hour = self.hour
            case .pm:
                hour = self.hour + 12
            }
        case .hours24:
            hour = self.hour
        }

        if let date = Date.from(year: year, month: month, day: day, hour: hour, minute: minute, second: second) {
            self.date = date
        }

    }

    @ViewBuilder private var timer24: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            CustomCircularWheelPicker(selection: $hour, items: hours) { value in
                if let hour = value {
                    Text(String(format: "%02d", hour))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fontWeight(config.fontWeight)
                        .font(config.font)
                } else {
                    Text("")
                }

            }
            .padding(.leading)
            Divider()
                .frame(height: config.height - config.rowHeight)
                .opacity(config.showDivider ? 1 : 0)
            CustomCircularWheelPicker(selection: $minute, items: minutes) { value in
                if let minute = value {
                    Text(String(format: "%02d", minute))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fontWeight(config.fontWeight)
                        .font(config.font)
                } else {
                    Text("")
                }
            }
            .padding(.trailing)
            Spacer(minLength: 0)
        }
        .background(SelectedPositionBackground(config: config))
        .padding(.horizontal)
        .onChange(of: hour, { _, _ in
            updateTime()
        })
        .onChange(of: minute, { _, _ in
            updateTime()
        })
        .onChange(of: amOrPm, { _, _ in
            updateTime()
        })
        .onAppear(perform: {
        })
    }

    @ViewBuilder private var timer12: some View {
        HStack(spacing: 0) {
            CustomCircularWheelPicker(selection: $hour, items: hours) { value in
                if let hour = value {
                    Text(String(format: "%02d", hour))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fontWeight(config.fontWeight)
                        .font(config.font)
                } else {
                    Text("")
                }
            }
            .padding(.leading)
            Divider()
                .frame(height: config.height - config.rowHeight)
                .opacity(config.showDivider ? 1 : 0)

            CustomCircularWheelPicker(selection: $minute, items: minutes) { value in
                if let minute = value {
                    Text(String(format: "%02d", minute))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fontWeight(config.fontWeight)
                        .font(config.font)
                } else {
                    Text("")
                }
            }
            Divider()
                .frame(height: config.height - config.rowHeight)
                .opacity(config.showDivider ? 1 : 0)
            CustomFiniteWheelPicker(selection: $amOrPm, items: amPm) { value in
                if let amOrPmValue = value {
                    Text(amOrPmValue.description)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .fontWeight(config.fontWeight)
                        .font(config.font)
                } else {
                    Text("")
                }
            }
            .padding(.trailing)
        }
        .background(SelectedPositionBackground(config: config))
        .padding(.horizontal)
        .onChange(of: hour, { _, _ in
            updateTime()
        })
        .onChange(of: minute, { _, _ in
            updateTime()
        })
        .onChange(of: amOrPm, { _, _ in
            updateTime()
        })
        .onAppear(perform: {
        })
    }

    public var body: some View {
        if format == .hours24 {
            timer24
        } else {
            timer12
        }
    }
}

#Preview {
    @Previewable @State var date = Date()
    TimerWheelPicker(date: $date, format: .hours12)
}

