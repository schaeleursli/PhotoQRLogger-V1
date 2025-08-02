import Foundation
import ZIPFoundation
import UIKit

class ProjectManager {
    static let shared = ProjectManager()

    private init() {}

    func exportProject(named projectName: String) -> URL? {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let projectURL = documentsURL.appendingPathComponent("Projects").appendingPathComponent(projectName)
        let zipURL = documentsURL.appendingPathComponent("\(projectName).zip")

        do {
            if fileManager.fileExists(atPath: zipURL.path) {
                try fileManager.removeItem(at: zipURL)
            }
            try fileManager.zipItem(at: projectURL, to: zipURL)
            return zipURL
        } catch {
            print("Error zipping project: \(error)")
            return nil
        }
    }

    func importProject(from zipURL: URL) -> Bool {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        do {
            try fileManager.unzipItem(at: zipURL, to: documentsURL.appendingPathComponent("Projects"))
            return true
        } catch {
            print("Failed to unzip project: \(error)")
            return false
        }
    }
}