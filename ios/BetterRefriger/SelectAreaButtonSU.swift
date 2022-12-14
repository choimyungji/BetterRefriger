//
//  SelectAreaButtonSU.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2021/07/13.
//  Copyright © 2021 maengji.com. All rights reserved.
//

import SwiftUI

struct SelectAreaButtonSU: View {
    var title: String

    var body: some View {
        ZStack {
            Circle()
                .size(CGSize(width: 54, height: 54))
                .foregroundColor(Color(rgbHex: 0xAAAAAA))
            Button(title) {
                print(title)
            }
        }
        .frame(width: 54, height: 54)
    }
}

struct SelectAreaButtonSU_Previews: PreviewProvider {
    static var previews: some View {
        SelectAreaButtonSU(title: "냉장")
    }
}
