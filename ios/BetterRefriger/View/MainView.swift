//
//  ContentView.swift
//  SwiftUITest1
//
//  Created by Myungji Choi on 2021/06/16.
//

import SwiftUI
import CoreData

struct MainView: View {

    @State var presentingModal = false
    @State var food: String = ""
    @State var spaceType = SpaceType()

    var viewModel: MainViewModel

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.foods(spaceType: spaceType)) { food in
                        FoodGridView(viewModel: FoodGridViewModel(food: food))
                    }
                }
                HStack {
                    VStack {
                        Spacer()
                        SelectAreaButtonSU(title: "냉장")
                        SelectAreaButtonSU(title: "냉동")
                    }
                    Spacer()
                }
                .padding(16)
            }
            .navigationBarTitle("더나은냉장고")
            .navigationBarItems(trailing:
                                    Button(action: {
                self.presentingModal = true
            }, label: {
                Image(systemName: "plus")
                    .resizable()
                    .padding(6)
                    .frame(width: 24, height: 24)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }).sheet(isPresented: $presentingModal) {
                FoodInputView(presentedAsModal: self.$presentingModal,
                              food: $food)
            })
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
