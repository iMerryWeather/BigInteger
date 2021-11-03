import XCTest
@testable import BigInteger

final class BigIntegerTests: XCTestCase {
    func testPublicInitFromStr() {
        let a = BigInteger(from: "0000000000000000000000000000000000000612361193061935861237")
        XCTAssertEqual(a.mag, [1193061935861237, 61236])
        XCTAssertEqual(a.signum, true)

        let b = BigInteger(from: "-6123611930619358612362")
        XCTAssertEqual(b.mag, [1930619358612362, 612361])
        XCTAssertEqual(b.signum, false)

        let c = BigInteger(from: "0")
        XCTAssertEqual(c.mag, [0])
        XCTAssertEqual(c.signum, true)
    }

    /*
     * this test only starts with non-private func
     * and included in init test.
     */
    /*func testPrivateRemoveLeadingZeros_arg_Array_UInt64() {
        let a = BigInteger(from: "0000000000000000000000000000000000000612361193061935861237")
        let b = BigInteger(from: "0000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(BigInteger.removeLeadingZeros(mag: a.mag),
                       BigInteger(from: "612361193061935861237").mag)
        XCTAssertEqual(BigInteger.removeLeadingZeros(mag: b.mag), [0])
    }*/

    /*
     * this test only starts with non-private func
     * and included in sub test.
     */
    /*func testPrivateComparAbs_arg_Array_UInt64_Array_UInt64() {
        //not same length
        let a = BigInteger(from: "0000000000000000000000000000000000000612361193061935861237")
        let b = BigInteger(from: "0000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(BigInteger.compareAbs(mag1: a.mag, mag2: b.mag), true)
        XCTAssertEqual(BigInteger.compareAbs(mag1: b.mag, mag2: a.mag), false)

        //same length
        let c = BigInteger(from: "193581935819358612361193061935861237")
        let d = BigInteger(from: "193581935819358612361193061935861233")
        XCTAssertEqual(BigInteger.compareAbs(mag1: c.mag, mag2: d.mag), true)
        XCTAssertEqual(BigInteger.compareAbs(mag1: d.mag, mag2: c.mag), false)
    }*/
}
