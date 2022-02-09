//
//  Bitwise operation.swift
//  
//
//  Created by Louis Shen on 2022/2/2.
//

extension BigInteger {

}

/*
 * Return two's-complement representation of this array, do not use on sigum is
 * TRUE
 */
extension Array where Element == UInt32 {
    mutating func twosComplement() {
        var isOverflow = true
        for i in 0 ..< self.count {
            if isOverflow {
                (self[i], isOverflow) = (~self[i]).addingReportingOverflow(1)
            } else {
                self[i] = ~self[i]
            }
        }
    }
}
