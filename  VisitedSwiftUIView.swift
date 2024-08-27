//
//   VisitedSwiftUIView.swift
//  focus1.0
//
//  Created by 문현권 on 2024/9/3.
//

import SwiftUI

struct VisitCalendarView: View {
    @ObservedObject var viewModel: CustomerViewModel
    @State private var selectedDate = Date()

    var body: some View {
        VStack {
            DatePicker(
                "Select Visit Date",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()

            List {
                ForEach(customersVisited(on: selectedDate)) { customer in
                    Text(customer.name)
                }
            }
        }
        .navigationTitle("Visit Calendar")
    }

    // 선택한 날짜에 방문한 고객 필터링
    func customersVisited(on date: Date) -> [Customer] {
        return viewModel.customers.filter { customer in
            guard let visitDate = customer.visitDate else { return false }
            let calendar = Calendar.current
            return calendar.isDate(visitDate, inSameDayAs: date)
        }
    }
}
