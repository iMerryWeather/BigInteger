//
//  Modulus.swift
//  
//
//  Created by Louis Shen on 2022/1/25.
//

extension BigInteger {
    //Currently we consider that r is non-negative number.
    private static func mod(lhs : BigInteger, rhs : BigInteger)
                        -> BigInteger {
        return lhs - lhs / rhs * rhs
                            //return BigInteger(signum: true,
                              //mag: divide(mag1: lhs.mag, mag2: rhs.mag).1)
    }
}

//Operator wrappers %, %=
extension BigInteger {
    public static func % (lhs : BigInteger, rhs : BigInteger) -> BigInteger {
        return mod(lhs: lhs, rhs: rhs)
    }
    
    public static func %= (lhs : inout BigInteger, rhs : BigInteger) {
        lhs = lhs % rhs
    }
}
