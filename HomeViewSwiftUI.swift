//
//  HomeViewSwiftUI.swift
//  focus1.0
//
//  Created by 문현권 on 2024/8/31.
//

import SwiftUI



struct HomeViewSwiftUI: View {
    @ObservedObject var viewModel = CustomerViewModel()
    
    var body: some View {
        VStack{
            // 문자열 보간을 사용하여 고객 수를 표시
            HStack{
                Text("전체고객:\(viewModel.customers.count)")
            }
            Text("어제방문한 거래처")
            let notVisitedCount = viewModel.customers.filter { !$0.visited }.count
            Text("방문하지 않은 개수: \(notVisitedCount)")
            Spacer()
            Text("이행제출 예정 거래처")
            ForEach(viewModel.customers) { customer in
                           if let dDay = customer.dDay {
                               HStack {
                                   Text(customer.name) // 고객 이름
                                   
                                   Text("D-DAY: \(dDay)일")
                                       .foregroundColor(dDay < 0 ? .red : .green)
                               }
                           }
                       }
            Spacer()
         }
     }
        }
    

struct HomeViewSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewSwiftUI()
    }
}
