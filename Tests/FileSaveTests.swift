import XCTest
@testable import PhotoQRLogger

final class FileSaveTests: XCTestCase {
    func testSaveAndLoadMetadataJSON() throws {
        let testData: [String: Any] = [
            "id": "CARGO123",
            "description": "Heavy load",
            "gps": [-33.45, -70.65]
        ]

        let fileManager = FileManager.default
        let tmp = fileManager.temporaryDirectory
        let fileURL = tmp.appendingPathComponent("test.json")

        let data = try JSONSerialization.data(withJSONObject: testData, options: [])
        try data.write(to: fileURL)

        let readData = try Data(contentsOf: fileURL)
        let decoded = try JSONSerialization.jsonObject(with: readData, options: []) as? [String: Any]

        XCTAssertEqual(decoded?["id"] as? String, "CARGO123")
        XCTAssertEqual(decoded?["description"] as? String, "Heavy load")
    }
}