//
//  RegisterButton.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2022/08/14.
//  Copyright © 2022 maengji.com. All rights reserved.
//

import SwiftUI

struct RegisterButton: View {
    let completion: () -> Void
    var body: some View {
        Button(
            action: completion) {
                Text("등록")
                    .foregroundColor(.brBlack)
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(Color.onActive)
    }
}

struct RegisterButton_Previews: PreviewProvider {
    static var previews: some View {
        RegisterButton {}
    }
}
