import SwiftUI



struct CustomerFormView: View {
    
    @ObservedObject var viewModel: CustomerViewModel
    
    @State var customer: Customer
    
    @State private var showingAlert = false //saveCustomer를 누르면 설정된 Alert이고, name이 비어있을때 "이름이 등록되지않았습니다" / or 등록되었습니다. 변수, bool타입
    
    @State private var alertMessage = "" // Alert가 뜨기 전 메시지 변수를 변경시키고 화면이 나옴,
    
    @State private var showCalendar = false //이행완료일 버튼 설정을 누르면 토글되어서 켈린더가 보여짐 .Sheet가 프렌테이션으로 나오면서 보여짐
    
    @State private var selectedStartDate: Date = Date() // 작업 시작 날짜
    @State private var selectedEndDate: Date = Date() // 작업 종료 날짜
    @State private var isStartDateSelected = false // 시작 날짜 선택 여부 추적
    @State private var visitedSelectedday: Date = Date()
    @State private var visitedcheck = false
    
    let addresses = ["선택안됨", "파주", "일산", "김포"]
    
    init(viewModel: CustomerViewModel, customer: Customer?) {  //?로 설정된 값들은 nil일 가능성이 있기때문에 옵셔널 바인딩을 이용해서 변수에 저장시켜서 안전하게 저장
        self.viewModel = viewModel
        if let existingCustomer = customer {
            _customer = State(initialValue: existingCustomer)
        } else {
            _customer = State(initialValue: Customer(id: nil, name: "", address: "선택안됨", size: "", customField1: "", customField2: "", visited: false))
        }
    } //뷰에서 보이는 상태관리뷰
    
    var body: some View {
        Form {
            
            Section(header: Text("Customer Details")) {
                TextField("C 이름", text: $customer.name)
                Picker("C 주소", selection: $customer.address) {
                    ForEach(addresses, id: \.self) { address in
                        Text(address)
                    }
                }
                TextField("C 안전관리자", text: $customer.size)
                TextField("C 금액", text: $customer.customField1)
                TextField("C 점검월", text: $customer.customField2)
                Toggle(isOn: $customer.visited) {
                    Text("방문 여부")
                }
                
                    Button(action: {
                        showCalendar.toggle() // 토글 되었기 때문에 false에서 true로, .시트의 $ 달린 [showcalendar 로 설정해놓아서 시트가 열림 ]
                    }) {
                        Text("이행 완료일 설정")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        visitedcheck.toggle()
                    }) {
                        Text("방문 날자 설정")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)

                    }

                // 초기 false상태에서 true로 반전시킨 상태임, 값을 반전시켜서 참인 화면을 바로 보여줌,
                // [!] 논리부정연산자 변수의 값은 바뀌지 않은 상태임
                // 그래서 데이트 피커 상태를 나오게 만듬. 그리고 버튼을 눌러서 true로 만들어서 바로 종료날자 선택으로 넘어가게 만듬
                // 버튼을 눌러서. true가 되어야 else문이 작동함/ 변수가 바뀌기 때문에
                .sheet(isPresented: $showCalendar) {  // 켈린더는 데이트피커와 .시트 뷰의 조합 덕분에 보여지는거임
                    VStack {
                        if !isStartDateSelected { // 값을 반전시켜서 참인 화면을 바로 보여줌,
                            DatePicker("시작 날짜 선택", selection: $selectedStartDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                            
                            Button(action: {
                                customer.startDate = selectedStartDate // 시작 날짜 저장
                                isStartDateSelected = true
                            }) {
                                Text("시작 날짜 설정")
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        } else { // isStartDateSelected 가 설정 되었다면 else 구문으로
                            // 종료 날짜 선택
                            DatePicker("종료 날짜 선택", selection: $selectedEndDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                            
                            Button(action: {
                                customer.endDate = selectedEndDate // 종료 날짜 저장
                                customer.dDay = customer.calculateDDay() // D-DAY 계산 및 저장
                                isStartDateSelected = false
                                showCalendar = false // 캘린더 닫기
                            }) {
                                Text("종료 날짜 설정")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                }
            }
            
            
           
            
            .sheet(isPresented: $visitedcheck) {
                VStack {
                    DatePicker("방문 날짜 선택", selection: $visitedSelectedday, displayedComponents: .date)  // 바인딩 변수로 수정
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()

                    Button(action: {
                        customer.visitDate = visitedSelectedday
                        visitedcheck = false // 시트 닫기
                    }) {
                        Text("방문 날짜 설정")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            
            // 선택한 날짜들과 D-DAY 표시 // 시트  설정 버튼에서  customer.startDate = selectedStartDate 저장됨
            Section(header: Text("Selected Dates and D-Days")) {
                if let startDate = customer.startDate {
                    HStack {
                        Text("시작 날짜: \(dateFormatter.string(from: startDate))")
                            .foregroundColor(.red)
                    }
                }
                // 선택한 날짜들과 D-DAY 표시 // 시트  설정 버튼에서  customer.startDate = selectedStartDate 저장됨
                if let endDate = customer.endDate {
                    HStack {
                        Text("종료 날짜: \(dateFormatter.string(from: endDate))")
                            .foregroundColor(.blue)
                    }
                }
                // 선택한 날짜들과 D-DAY 표시 // 시트  설정 버튼에서  customer.startDate = selectedStartDate 저장됨
                if let dDay = customer.dDay {
                    HStack {
                        Text("D-DAY: \(dDay)일")
                            .foregroundColor(dDay < 0 ? .red : .green)
                    }
                }
                
                if let visitedday = customer.visitDate {
                    HStack {
                        Text("방문 날짜: \(dateFormatter.string(from:visitedday))일")
                            
                    }
                }
            }
            
            Button(action: saveCustomer) {
                Text("Save")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .alert(isPresented: $showingAlert) {   // saveCustoemr버튼에 다 달아놓음,
                Alert(
                    title: Text(alertMessage),
                    message: nil,
                    dismissButton: .default(Text("확인"))
                )
            }
        }
        .navigationTitle(customer.id == nil ? "Add Customer" : "Edit Customer")
        // 아이디값이 Nil이면 ADD, : 있으면 edit
    }
    
    private func saveCustomer() {
        // 고객 이름이 비어 있는지 확인
        guard !customer.name.isEmpty // 문자열이 비어있지 않으면 코드를 쭉 실행, [!] 논리부정이 붙어있지 않으면 true로 인식
                // else는 위의 말을 따르기 때문에 비어있으면 else구문을 실행하겠다 란 의미가 됨
        else {
            alertMessage = "이름이 등록되지 않았습니다"
            showingAlert = true
            return
        }
        
        if customer.id == nil {
            viewModel.addCustomer(customer: customer)
        } else {
            viewModel.updateCustomer(customer: customer)
        }
        
        // 알림 메시지 설정
        alertMessage = "등록되었습니다"
        showingAlert = true
        
        // 텍스트 필드 초기화
        customer.name = ""
        customer.address = "선택안됨"
        customer.size = ""
        customer.customField1 = ""
        customer.customField2 = ""
        customer.visited = false
        customer.startDate = nil
        customer.endDate = nil
        customer.dDay = nil
        
        UIApplication.shared.endEditing(true)
    }
    
    private let dateFormatter: DateFormatter = {  //데이터를 문자열로 변환하는 방식, 시작날짜 종료날짜를 표시해줌
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ko_KR")  // 한국어로 설정
        return formatter
    }()
}


extension UIApplication {
    func endEditing(_ force: Bool) {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}   // 키보드 닫는 익스텐션

struct CustomerFormView_Previews: PreviewProvider {
    static var previews: some View {
        // 미리보기용 ViewModel 및 Customer 객체 생성
        let previewViewModel = CustomerViewModel()
        let previewCustomer = Customer(id: "1", name: "", address: "", size: "", customField1: " 1", customField2: "", visited: true, startDate: Date(), endDate: Date(), dDay: 5, visitDate: Date())
        
        // 프리뷰에서 뷰를 미리보기
        CustomerFormView(viewModel: previewViewModel, customer: previewCustomer)
    }
}



// 방문 여부를 토글했을때.
// 켈린더 시트가 나온다 . 켈린더 시트에서 선택하고 방문날자 save버튼을 눌러서 저장하면 visetedday가 저장된다.
//모델에 var visitDate: Date? 프로퍼티는 만들어놓음
// 토글스위치가 true가 되었을때 켈린더가 나오게 해서 , 비짓세이브데이트를
