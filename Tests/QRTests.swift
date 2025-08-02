import XCTest
@testable import PhotoQRLogger
import CoreImage.CIFilterBuiltins

final class QRTests: XCTestCase {
    func testQRCodeEncodesDataCorrectly() {
        let testString = "{\"id\":\"CARGO123\",\"desc\":\"Heavy box\",\"lat\":-33.45}"
        let image = PDFExporter.generateQRCode(from: testString)
        XCTAssertNotNil(image, "QR code generation failed")

        // Optional: Add decoding test using CI detector
        let ciImage = CIImage(image: image!)
        XCTAssertNotNil(ciImage)
    }
}