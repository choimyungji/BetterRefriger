//
//  ModalView.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2022/08/14.
//  Copyright © 2022 maengji.com. All rights reserved.
//

import SwiftUI

struct FoodInputView: View {

    @Binding var presentedAsModal: Bool
    @Binding var food: String

    @State private var foodName: String = ""
    @State private var registerDate: Date = Date()
    @State private var expireDate: Date = Date()
    @State private var favoriteColor = 0

    var viewModel = FoodInputViewModel(spaceType: SpaceType(keyString: "refriger"))

    var body: some View {
        ZStack {
            ScrollView {
                Spacer(minLength: 16)
                Picker("What is your favorite color?", selection: $favoriteColor) {
                    Text("냉장고").tag(0)
                    Text("냉동실").tag(1)
                }
                .pickerStyle(.segmented)
                .padding([.leading, .trailing], 16)

                Text("식품명")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 16)
                TextField("식품명", text: $foodName)
                    .padding([.leading, .trailing], 16)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Text("등록일")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    LabelButtonSwiftUI("오늘") {
                        registerDate = Date()
                    }
                }
                .padding([.leading, .trailing], 16)

                DatePicker("", selection: $registerDate, displayedComponents: [.date])
                    .fixedSize()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 16)

                HStack {
                    Text("유통기한")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    LabelButtonSwiftUI("1주일") {
                        expireDate = Calendar.current.date(byAdding: .day, value: 7, to: expireDate) ?? Date()
                    }
                    LabelButtonSwiftUI("1달") {
                        expireDate = Calendar.current.date(byAdding: .month, value: 1, to: expireDate) ?? Date()
                    }
                }
                .padding([.leading, .trailing], 16)

                DatePicker("", selection: $expireDate, displayedComponents: [.date])
                    .fixedSize()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 16)
            }
            VStack {
                Spacer()
                RegisterButton {
                    viewModel.add(food: FoodModel(name: foodName,
                                                  registerDate: registerDate,
                                                  expireDate: expireDate))
                    self.presentedAsModal = false
                }
            }
        }
    }
}

struct FoodInputView_Previews: PreviewProvider {
    static var previews: some View {
        FoodInputView(presentedAsModal: .constant(true),
                      food: .constant(""))
    }
}
