//
//  FoodGridView.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2022/08/20.
//  Copyright © 2022 maengji.com. All rights reserved.
//

import SwiftUI

struct FoodGridView: View {
    var viewModel: FoodGridViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.name)
                .font(.system(size: 22, weight: .medium))
                .padding(.bottom, -8)
            HStack {
                Text("\(viewModel.expireDate)까지 ")
                    .font(.system(size: 16, weight: .regular))
                if viewModel.isSoon {
                    Text("유통기한임박")
                        .font(.system(size: 15))
                        .padding(.init(top: 2, leading: 5, bottom: 2, trailing: 5))
                        .background(Color.onActive)
                        .cornerRadius(6)
                }
            }
        }
    }
}

struct FoodGridViewModel {
    var food: FoodModel

    var name: String {
        food.name
    }

    var expireDate: String {
        convertExpireFormat(date: food.expireDate)
    }

    var isSoon: Bool {
        true
    }

    private func convertExpireFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

struct FoodGridView_Previews: PreviewProvider {
    static var previews: some View {
        FoodGridView(
            viewModel: FoodGridViewModel(
                food: FoodModel(name: "계란",
                                registerDate: Date(),
                                expireDate: Date())))
    }
}
