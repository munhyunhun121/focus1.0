//
//  focus1_0App.swift
//  focus1.0
//
//  Created by 문현권 on 2024/8/27.
//


import SwiftUI
import Firebase

//struct ContentView: View {
//    @ObservedObject var viewModel = CustomerViewModel()
//
//    var body: some View {
//        NavigationView {
//            CustomerFormView(viewModel: viewModel, customer: nil)
//        }
//    }
//}


@main                             //메인앱에서  [컨텐츠뷰로 뷰]를 띄운다 -> 컨텐츠뷰 안에는 -> [커스터머 폼뷰] 가 바디에 들어가있다. 1. 커스터머 폼뷰 안에 네비로 유아이뷰

struct YourAppNameApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            SwiftTebUIView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
