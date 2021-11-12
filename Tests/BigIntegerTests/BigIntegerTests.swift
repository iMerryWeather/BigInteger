import XCTest
@testable import BigInteger

final class BigIntegerTests: XCTestCase {
    func testPublicInitFromStr() {
        let a = BigInteger(from: "0000000000000000000000000000000000000612361193061935861237")
        XCTAssertEqual(a.mag, [1125502453, 842529961, 33])
        XCTAssertEqual(a.signum, true)

        let b = BigInteger(from: "-0006123611930619358612362")
        XCTAssertEqual(b.mag, [2665089930, 4130332316, 331])
        XCTAssertEqual(b.signum, false)

        let c = BigInteger(from: "0")
        XCTAssertEqual(c.mag, [0])
        XCTAssertEqual(c.signum, true)
    }

    func testAddMag() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "61935861237")
        //c_mag = [3138768373, 3505532565, 28376639]
        let c = BigInteger(from: "523456612361193061935861237")
        //d_mag = [1946157056, 1340620830, 27105054]
        let d = BigInteger(from: "500000000000000000000000000")
        XCTAssertEqual(a.add(mag1: a.mag, mag2: b.mag), [2931821546, 842529975, 33])
        XCTAssertEqual(c.add(mag1: c.mag, mag2: c.mag), [1982569450, 2716097835, 56753279])
        XCTAssertEqual(c.add(mag1: d.mag, mag2: d.mag), [3892314112, 2681241660, 54210108])

    }

    /*func testSubtractMag() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "61935861237")
        let c = BigInteger(from: "523456612361193061935861237")
        let d = BigInteger(from: "500000000000000000000000000")
        XCTAssertEqual(a.subtract(mag1: a.mag, mag2: b.mag), [0, 361193000, 612])
        XCTAssertEqual(c.subtract(mag1: c.mag, mag2: d.mag), [935861237, 361193061, 23456612])
        XCTAssertEqual(c.subtract(mag1: d.mag, mag2: d.mag), [0])

    }

    func testMulMag() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "61935861237")
        let c = BigInteger(from: "523456612361193061935861237")
        let d = BigInteger(from: "500000000000000000000000000")

        XCTAssertEqual(a.multiply(mag1: a.mag, mag2: b.mag), [919170169, 826648168, 117880407, 37927])
        XCTAssertEqual(c.multiply(mag1: c.mag, mag2: d.mag), [0, 0, 500000000, 967930618, 180596530, 261728306])
        XCTAssertEqual(c.multiply(mag1: c.mag, mag2: [0]), [0])
    }*/

    /*func testAdd() {
        let a = BigInteger(from: "0000000000000000000000000000000000000612361193061935861237")
        //let b = BigInteger(from: "-6123611930619358612362")
        XCTAssertEqual((a + a).mag, BigInteger(from: "1224722386123871722474").mag)
        XCTAssertEqual((a + a).signum, BigInteger(from: "1224722386123871722474").signum)
    }*/

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
