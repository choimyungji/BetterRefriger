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
                Text("Hello, world!")
                    .padding()
                Text("Hello, world!")
                    .padding()
            }
            Circle()
                .size(CGSize(width: 50, height: 50))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(foods: [])
    }
}
