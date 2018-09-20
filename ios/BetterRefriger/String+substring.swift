//
//  String+substring.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 2018. 9. 20..
//  Copyright © 2018년 maengji.com. All rights reserved.
//

import Foundation

extension String {
    func substring(from: Int, to: Int) -> String? {
        guard count > from && count > to && from < to else {
            return nil
        }
        let index1 = self.index(self.startIndex, offsetBy: from)
        let index2 = self.index(self.startIndex, offsetBy: to)
        return String(self[index1...index2])
    }

    func substring(from: Int, length: Int) -> String? {
        guard count > from && count > from+length else {
            return nil
        }
        let index1 = self.index(self.startIndex, offsetBy: from)
        let index2 = self.index(self.startIndex, offsetBy: from+length)
        return String(self[index1..<index2])
    }

    func substring(from: Int) -> String? {
        guard count > from else {
            return nil
        }
        let index = self.index(self.startIndex, offsetBy: from)
        return String(self[index...])
    }

    func substring(to: Int) -> String? {
        guard count > to else {
            return nil
        }
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[...index])
    }
}
