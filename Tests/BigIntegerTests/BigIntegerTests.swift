import XCTest
@testable import BigInteger

final class BigIntegerTests: XCTestCase {
    func testPublicInitFromStr() {
        let a = BigInteger(from:
                "0000000000000000000000000000000000000612361193061935861237")
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
        XCTAssertEqual(a.add(mag1: a.mag, mag2: b.mag),
                       [2931821546, 842529975, 33])
        XCTAssertEqual(c.add(mag1: c.mag, mag2: c.mag),
                       [1982569450, 2716097835, 56753279])
        XCTAssertEqual(c.add(mag1: d.mag, mag2: d.mag),
                       [3892314112, 2681241660, 54210108])

    }

    func testSubtractMag() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "61935861237")
        let c = BigInteger(from: "523456612361193061935861237")
        let d = BigInteger(from: "500000000000000000000000000")
        XCTAssertEqual(a.subtract(mag1: a.mag, mag2: b.mag),
                       [3614150656, 842529946, 33])
        XCTAssertEqual(c.subtract(mag1: c.mag, mag2: d.mag),
                       [1192611317, 2164911735, 1271585])
        XCTAssertEqual(c.subtract(mag1: d.mag, mag2: d.mag), [0])

    }

    func testMulMag() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "61935861237")
        let c = BigInteger(from: "523456612361193061935861237")
        let d = BigInteger(from: "500000000000000000000000000")

        XCTAssertEqual(a.multiply(mag1: a.mag, mag2: b.mag),
                       [2443410553, 2573930479, 3038812614, 478])
        XCTAssertEqual(c.multiply(mag1: c.mag, mag2: d.mag),
            [67108864, 2044281865, 1819053428, 197960665, 3325078967, 179081])
        XCTAssertEqual(c.multiply(mag1: c.mag, mag2: [0]), [0])
    }

    func testDivMag() {
        let a = BigInteger(from: "612361193061935861237")
        let b = BigInteger(from: "61935861237")
        let c = BigInteger(from: "523456612361193061935861237")
        let d = BigInteger(from: "500000000000000000000000000")

        //hack, should be fixed in division(mag1:_, mag2:_) v1.1b1
        let e = BigInteger(from: "612361193061935861237324234354353452352542352435435252435453")
        let f = BigInteger(from: "1000000000000000000")
        print("\(UInt32(truncatingIfNeeded: -587411230))")

        XCTAssertEqual(e.divide(mag1: e.mag, mag2: f.mag).0, [4274521118, 267499566, 3951190577, 2438715792, 1799, 0])
        XCTAssertEqual(a.divide(mag1: a.mag, mag2: b.mag).0, [1297086930, 2])
        XCTAssertEqual(a.divide(mag1: a.mag, mag2: b.mag).1, [2341514747, 6])
        XCTAssertEqual(c.divide(mag1: c.mag, mag2: d.mag).0, [1])
        XCTAssertEqual(c.divide(mag1: c.mag, mag2: d.mag).1, [1192611317, 2164911735, 1271585])
    }

    func testStringConvertible() {
        let a = BigInteger(from: "612361193061935861237")
        XCTAssertEqual(String(a), "612361193061935861237")
        let b = BigInteger(from: "-612361193061935861237324234354353452352542352435435252435453")
        XCTAssertEqual(String(b), "-612361193061935861237324234354353452352542352435435252435453")
    }

    /*func testAdd() {
        let a = BigInteger(from: "0000000000000000000000000000000000000612361193061935861237")
        //let b = BigInteger(from: "-6123611930619358612362")
        XCTAssertEqual((a + a).mag, BigInteger(from: "1224722386123871722474").mag)
        XCTAssertEqual((a + a).signum, BigInteger(from: "1224722386123871722474").signum)
    }*/
}
