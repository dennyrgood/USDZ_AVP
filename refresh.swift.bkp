#!/usr/bin/env swift
import Foundation
import SceneKit
import SceneKit.ModelIO
import AppKit

class ARQLThumbnailGenerator {
    private let device = MTLCreateSystemDefaultDevice()!
    
    func thumbnail(for url: URL, size: CGSize, time: TimeInterval = 0) -> NSImage? {
        let renderer = SCNRenderer(device: device, options: [:])
        renderer.autoenablesDefaultLighting = true
        
        let asset = MDLAsset(url: url)
        asset.loadTextures()
        let scene = SCNScene(mdlAsset: asset)
        
        // Check if scene has content
        guard scene.rootNode.childNodes.count > 0 else {
            return nil
        }
        
        renderer.scene = scene
        let image = renderer.snapshot(atTime: time, with: size, antialiasingMode: .multisampling4X)
        return image
    }
}

// Main execution
let args = CommandLine.arguments
let directory = args.count >= 2 ? args[1] : "."
let generator = ARQLThumbnailGenerator()
let files = try FileManager.default.contentsOfDirectory(atPath: directory).filter { $0.hasSuffix(".usdz") }

// Create log file
let logPath = directory + "/usdz_thumbnailer.log"
let logFile = open(logPath, O_WRONLY | O_CREAT | O_TRUNC, 0o644)

var successCount = 0
var failCount = 0

for file in files {
    let inputURL = URL(fileURLWithPath: directory + "/" + file)
    let outputPath = directory + "/" + file.replacingOccurrences(of: ".usdz", with: ".png")
    let outputURL = URL(fileURLWithPath: outputPath)
    
    // Check if thumbnail exists and is newer than USDZ
    var shouldGenerate = true
    if FileManager.default.fileExists(atPath: outputPath) {
        do {
            let usdzAttributes = try FileManager.default.attributesOfItem(atPath: inputURL.path)
            let pngAttributes = try FileManager.default.attributesOfItem(atPath: outputPath)
            
            if let usdzDate = usdzAttributes[.modificationDate] as? Date,
               let pngDate = pngAttributes[.modificationDate] as? Date {
                shouldGenerate = usdzDate > pngDate
                if !shouldGenerate {
                    print("- \(file) (up to date)")
                    continue
                }
            }
        } catch {
            // If we can't check dates, generate anyway
        }
    }
    
    // Redirect stderr to log file
    let originalStderr = dup(STDERR_FILENO)
    dup2(logFile, STDERR_FILENO)
    
    let thumbnail = generator.thumbnail(for: inputURL, size: CGSize(width: 512, height: 512))
    
    // Restore stderr
    dup2(originalStderr, STDERR_FILENO)
    close(originalStderr)
    
    if let thumbnail = thumbnail {
        let data = thumbnail.tiffRepresentation!
        let bitmap = NSBitmapImageRep(data: data)!
        let pngData = bitmap.representation(using: .png, properties: [:])!
        try pngData.write(to: outputURL)
        print("✓ \(file)")
        successCount += 1
    } else {
        print("✗ \(file)")
        failCount += 1
    }
}

print("Done: \(successCount) success, \(failCount) failed")
close(logFile)
if failCount > 0 {
    print("Errors logged to: \(logPath)")
}

// Run generate_index_with_USDZ.sh if it exists
let generateIndexScript = directory + "/generate_index_with_USDZ.sh"
if FileManager.default.fileExists(atPath: generateIndexScript) {
    print("Running generate_index_with_USDZ.sh...")
    let process = Process()
    process.currentDirectoryPath = directory
    process.executableURL = URL(fileURLWithPath: "/bin/bash")
    process.arguments = ["generate_index_with_USDZ.sh"]
    try process.run()
    process.waitUntilExit()
    print("Generate index completed with exit code: \(process.terminationStatus)")
} else {
    print("No generate_index_with_USDZ.sh found, skipping index generation")
}

// Run deploy.sh if it exists
let deployScript = directory + "/deploy.sh"
if FileManager.default.fileExists(atPath: deployScript) {
    print("Running deploy.sh...")
    let process = Process()
    process.currentDirectoryPath = directory
    process.executableURL = URL(fileURLWithPath: "/bin/bash")
    process.arguments = ["deploy.sh"]
    try process.run()
    process.waitUntilExit()
    print("Deploy completed with exit code: \(process.terminationStatus)")
} else {
    print("No deploy.sh found, skipping deployment")
}
