import XCTest
@testable import BigInteger

final class BigIntegerTests: XCTestCase {
    func testInit() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "-612361193061935861236")
        print(a.mag)
        print((a + a).sub(mag: a.mag))
        XCTAssertEqual((a + a).toString(), "1224722386123871722474")
        //XCTAssertEqual(a.mag, [61236, 6123611930619358])
        //XCTAssertEqual(b.mag, [61236, 6123611930619358])
    }

    func testExample() throws {
        let bi = BigInteger(from: "612361193061935861236")
        print("bi.mag: \(bi.mag)")

        let BASE : UInt64 = 10000000000000000
        var mag1 : [UInt64] = [6123611930619358, 6123611930619358]
        var mag2 : [UInt64] = [6123611930619358, 6123611930619358]

        //Add zeros if two mags don't have same length
        if mag1.count < mag2.count {
            for _ in mag1.count ..< mag2.count {
                mag1.append(0)
            }
        } else {
            for _ in mag2.count ..< mag1.count {
                mag2.append(0)
            }
        }

        var res = [UInt64]()

        var carry : UInt64 = 0
        for i in 0 ..< mag1.count {
            res.append(mag1[i] + mag2[i] + carry)
            if res[i] >= BASE {
                res[i] -= BASE
                carry = 1
            } else {
                carry = 0
            }
        }
        //Last carry
        if carry == 1 {
            res.append(1)
        }

        print(res)
    }
}
