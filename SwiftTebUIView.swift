//
//  SwiftTebUIView.swift
//  focus1.0
//
//  Created by 문현권 on 2024/8/30.
//

import SwiftUI

struct SwiftTebUIView: View {
    
    @StateObject private var viewModel = CustomerViewModel()
    
    var body: some View {
        
        TabView {
                   CustomerListView(viewModel: viewModel)  // 고객 목록 화면 customerUIView
                       .tabItem {
                           Label("Customers", systemImage: "person.3.fill")
                           
                       }
            
                  HomeViewSwiftUI(viewModel: viewModel)
                   .tabItem {
                       Label("Home", systemImage: "star.fill")
                   }

                   NavigationView {
                       CustomerFormView(viewModel: viewModel, customer: nil)  // 고객 추가 화면 Formview
                   }
                   .tabItem {
                       Label("Add Customer", systemImage: "plus.circle.fill")
                   }
               }
           }
       }

struct SwiftTebUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftTebUIView()
    }
}
