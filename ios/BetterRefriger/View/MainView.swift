//
//  ContentView.swift
//  SwiftUITest1
//
//  Created by Myungji Choi on 2021/06/16.
//

import SwiftUI
import CoreData

struct MainView: View {
    var foods: [NSManagedObject]

    var body: some View {
        ZStack {
            List {
                Text("Hello, world!")
                    .padding()
            }
            HStack {
                VStack {
                    Spacer()
                    SelectAreaButtonSU()
                        .frame(width: 54, height: 54)
                    SelectAreaButtonSU()
                        .frame(width: 54, height: 54)
                }
                Spacer()
            }
            .padding(.leading, 16)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(foods: [])
    }
}
