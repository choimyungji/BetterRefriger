//
//  ContentView.swift
//  SwiftUITest1
//
//  Created by Myungji Choi on 2021/06/16.
//

import SwiftUI
import CoreData

struct MainView: View {
    var viewModel: MainViewModel!
    var foods: [FoodModel] {
        viewModel.foods(spaceType: SpaceType())
    }

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(foods) { food in
                        Text(food.name)
                    }
                }
                HStack {
                    VStack {
                        Spacer()
                        SelectAreaButtonSU(title: "냉장")
                            .frame(width: 54, height: 54)
                        SelectAreaButtonSU(title: "냉동")
                            .frame(width: 54, height: 54)
                    }
                    Spacer()
                }
                .padding(.leading, 16)
            }
            .navigationBarTitle("더나은냉장고")
            .navigationBarItems(trailing:
                                    Button(action: {
                print("Done something")
            }, label: {
                Image(systemName: "plus")
                    .resizable()
                    .padding(6)
                    .frame(width: 24, height: 24)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
