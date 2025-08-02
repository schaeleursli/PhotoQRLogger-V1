import UIKit
import SwiftUI
import PDFKit
import CoreImage.CIFilterBuiltins

struct Metadata {
    let description: String
    let date: String
    let coordinates: String
    let user: String
    let company: String
    let logo: UIImage?
    let qrData: String
}

class PDFExporter {
    static func createPDF(from image: UIImage, metadata: Metadata, outputURL: URL) {
        let pdfMeta = [
            kCGPDFContextCreator: "PhotoQRLogger",
            kCGPDFContextAuthor: metadata.user
        ]
        UIGraphicsBeginPDFContextToFile(outputURL.path, .zero, pdfMeta as [String : Any])
        UIGraphicsBeginPDFPage()

        guard UIGraphicsGetCurrentContext() != nil else {
            UIGraphicsEndPDFContext()
            return
        }

        let pageWidth = 595.2
        let pageHeight = 841.8
        let imageRect = CGRect(x: 50, y: 40, width: 495, height: 300)
        image.draw(in: imageRect)

        let font = UIFont.systemFont(ofSize: 12)
        let attributes = [NSAttributedString.Key.font: font]

        let textYStart: CGFloat = imageRect.maxY + 20
        let textSpacing: CGFloat = 20

        let metadataText = [
            "Description: \(metadata.description)",
            "Date: \(metadata.date)",
            "Location: \(metadata.coordinates)",
            "User: \(metadata.user)",
            "Company: \(metadata.company)"
        ]

        for (index, line) in metadataText.enumerated() {
            let textRect = CGRect(x: 50, y: textYStart + CGFloat(index) * textSpacing, width: 400, height: 20)
            line.draw(in: textRect, withAttributes: attributes)
        }

        if let logo = metadata.logo {
            let logoRect = CGRect(x: 450, y: textYStart + 60, width: 80, height: 80)
            logo.draw(in: logoRect)
        }

        if let qrImage = generateQRCode(from: metadata.qrData) {
            let qrRect = CGRect(x: 220, y: textYStart + 140, width: 120, height: 120)
            qrImage.draw(in: qrRect)
        }

        UIGraphicsEndPDFContext()
    }

    static func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        guard let qrCIImage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQR = qrCIImage.transformed(by: transform)

        if let cgImage = context.createCGImage(scaledQR, from: scaledQR.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}