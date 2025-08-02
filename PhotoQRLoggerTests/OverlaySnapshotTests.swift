import XCTest
import SnapshotTesting
@testable import PhotoQRLogger

final class OverlaySnapshotTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        isRecording = false  // Set to true to record new snapshots
    }

    func testOverlayRendering() {
        let base = UIImage(systemName: "photo")!
        let qr = generateQRCode(from: "test data")!

        let metadata = PhotoMetadata(
            user: "Tester",
            datetime: "2025-08-02 12:00",
            gps: .init(lat: -33.4, lon: -70.6),
            description: "Snapshot test"
        )

        let result = overlayDataOnPhoto(photo: base, metadata: metadata, qrImage: qr, logoImage: nil)!

        assertSnapshot(matching: result, as: .image, named: "OverlayStandard")
    }
}