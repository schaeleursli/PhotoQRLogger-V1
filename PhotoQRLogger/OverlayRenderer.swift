import UIKit

struct PhotoMetadata {
    struct GPS {
        let lat: Double
        let lon: Double
    }

    let user: String
    let datetime: String
    let gps: GPS
    let description: String
}

/// Renders an image by overlaying metadata, a QR code, and an optional logo
/// on top of the provided photo.
/// - Parameters:
///   - photo: The base photo to draw onto.
///   - metadata: Descriptive information to render as text.
///   - qrImage: Generated QR code image.
///   - logoImage: Optional company logo.
/// - Returns: A new `UIImage` containing the combined content.
func overlayDataOnPhoto(
    photo: UIImage,
    metadata: PhotoMetadata,
    qrImage: UIImage,
    logoImage: UIImage?
) -> UIImage? {
    let size = photo.size
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    defer { UIGraphicsEndImageContext() }

    photo.draw(in: CGRect(origin: .zero, size: size))

    let padding: CGFloat = 8

    // Draw QR code at bottom-right
    let qrSide = min(size.width, size.height) / 4
    let qrRect = CGRect(
        x: size.width - qrSide - padding,
        y: size.height - qrSide - padding,
        width: qrSide,
        height: qrSide
    )
    qrImage.draw(in: qrRect)

    // Draw logo in top-right if provided
    if let logo = logoImage {
        let logoSide = qrSide / 2
        let logoRect = CGRect(
            x: size.width - logoSide - padding,
            y: padding,
            width: logoSide,
            height: logoSide
        )
        logo.draw(in: logoRect)
    }

    // Prepare metadata text
    let text = "User: \(metadata.user)\n" +
               "Date: \(metadata.datetime)\n" +
               String(format: "GPS: %.4f, %.4f\n", metadata.gps.lat, metadata.gps.lon) +
               "Description: \(metadata.description)"

    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.white,
    ]

    let textRect = CGRect(
        x: padding,
        y: padding,
        width: size.width - qrSide - 3 * padding,
        height: size.height - 2 * padding
    )

    // Draw a semi-transparent background for readability
    let backgroundPath = UIBezierPath(
        roundedRect: textRect.insetBy(dx: -padding/2, dy: -padding/2),
        cornerRadius: 4
    )
    UIColor.black.withAlphaComponent(0.5).setFill()
    backgroundPath.fill()

    text.draw(with: textRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

    return UIGraphicsGetImageFromCurrentImageContext()
}

