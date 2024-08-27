//
//  ViewModel.swift
//  focus1.0
//
//  Created by 문현권 on 2024/8/29.
//
// 1. 인정해야될 것, 큰돈을 버는 서비스는 아니다.
// 2. 내 할 수 있다는 증명을 하는 서비스를 만드는 것이다. 그것도 사람들이 돈을 내게하는 서비스를 만드는것이다.
// 3. 진실에 다가가야 된다. 나는 출시할 서비스를 만드는거지 뭘 이쁘게 만드려고 하는게 아니다.
// 4. 불편한걸 해소시켜야한다. 없으면 안될것을 만들어야하고 현재까지 존재하는 모든것보다 더 나아야한다. 그래야 쓴다.

import Foundation
import FirebaseFirestore
import Combine

class CustomerViewModel: ObservableObject {
    
    @Published var customers = [Customer]()
    
    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()

    private var timer: Timer?
    
    
    init() {
        fetchCustomers()
        
        timer = Timer.scheduledTimer(withTimeInterval: 86400, repeats: true) { _ in
                 self.updateDDays()
             }
    }

    
    func saveCustomer(customer: Customer) {
           // 고객 정보 업데이트 로직
       }
    
    func fetchCustomers() { //데이터를 가져오는 함수
        db.collection("customers").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error fetching customers: \(error)")
                return
            }

            self.customers = querySnapshot?.documents.compactMap { document in
                try? document.data(as: Customer.self)
            } ?? []
        }
        
    }

    func addCustomer(customer: Customer) { //데이터 추가함수
        do {
            _ = try db.collection("customers").addDocument(from: customer)
        } catch let error {
            print("Error adding customer: \(error)")
        }
    }

    func updateCustomer(customer: Customer) { //데이터 업데이트 함수
        if let id = customer.id {
            do {
                try db.collection("customers").document(id).setData(from: customer)
            } catch let error {
                print("Error updating customer: \(error)")
            }
        }
    }

    func deleteCustomer(customerId: String?) {
           guard let id = customerId else {
               print("Error: Customer ID is missing.")
               return
           }

           // Firestore에서 고객 삭제
           db.collection("customers").document(id).delete { error in
               if let error = error {
                   print("Error deleting customer: \(error)")
               } else {
                   DispatchQueue.main.async {
                       // 로컬 배열에서 고객 삭제
                       if let index = self.customers.firstIndex(where: { $0.id == id }) {
                           self.customers.remove(at: index)
                           print("Removed customer with ID: \(id)")
                       } else {
                           print("Error: Customer not found in local array.")
                       }
                   }
               }
           }
       }
   

    
    deinit {
           // 타이머 해제
           timer?.invalidate()
       }

       func updateDDays() {
           for i in customers.indices {
               customers[i].dDay = customers[i].calculateDDay()
           }
       }
       
       var customersWithDDay: [Customer] {
           return customers.filter { $0.dDay != nil }
       }
    
    
    
}

