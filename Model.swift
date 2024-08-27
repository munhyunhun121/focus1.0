//
//  Model.swift
//  focus1.0
//
//  Created by 문현권 on 2024/8/29.
//

import Foundation
import FirebaseFirestoreSwift

struct Customer: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var address: String
    var size: String
    var customField1: String
    var customField2: String
    var visited: Bool 
    // 필요한 다른 필드를 추가하세요.
    var startDate: Date? // 작업 시작 날짜
    var endDate: Date? // 작업 종료 날짜
    var dDay: Int? // D-DAY 값 저장
    var visitDate: Date?
    func calculateDDay() -> Int? {
         guard let startDate = startDate, let endDate = endDate else { return nil }
         let calendar = Calendar.current
         let startOfDay = calendar.startOfDay(for: startDate)
         let endOfDay = calendar.startOfDay(for: endDate)
         let components = calendar.dateComponents([.day], from: startOfDay, to: endOfDay)
         return components.day
     }
}


