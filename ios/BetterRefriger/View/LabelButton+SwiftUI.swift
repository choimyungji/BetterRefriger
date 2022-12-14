//
//  LabelButton+SwiftUI.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2022/08/15.
//  Copyright © 2022 maengji.com. All rights reserved.
//

import SwiftUI

struct LabelButtonSwiftUI: View {
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15))
                .padding(.init(top: 2, leading: 6, bottom: 2, trailing: 6))
                .background(Color.onActive)
                .foregroundColor(.brBlack)
        }
        .cornerRadius(3.0)
    }
}

struct LabelButtonSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        LabelButtonSwiftUI("오늘") { }
    }
}
