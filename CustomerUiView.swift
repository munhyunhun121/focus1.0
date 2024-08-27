import SwiftUI

struct CustomerListView: View {
    @ObservedObject var viewModel = CustomerViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.customers) { customer in
                    // 네비게이션 링크는 커스터머 폼뷰로 넘어감,
                    NavigationLink(destination: CustomerFormView(viewModel: viewModel, customer: customer)) {
                        HStack {
                            Text(customer.name)
                            if customer.visited {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let customer = viewModel.customers[index]
                        viewModel.deleteCustomer(customerId: customer.id)
                    }
                }
            }
            .navigationTitle("Customers")
            .navigationBarItems(trailing: EditButton()) // 목록에서 삭제 버튼 활성화
        }
    }
}

struct CustomerListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerListView()
    }
}
