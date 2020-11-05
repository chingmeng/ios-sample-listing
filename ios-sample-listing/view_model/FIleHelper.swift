//
//  FIleHelper.swift
//  ios-sample-listing
//
//  Created by Meng on 05/11/2020.
//  Copyright © 2020 Meng. All rights reserved.
//

import Foundation

class FileHelper {
	
	static let instance = FileHelper()
	private init() {}
	
	let manager: FileManager = FileManager.default
	var documentDir: URL? {
		return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
	}
	
	func delete(url: URL) -> Bool {
		do {
			try FileManager.default.removeItem(at: url)
		} catch let error as NSError {
			return false
		}
		return true
	}
	
	func listDirIn(directoryURL: URL) -> [URL]? {
		return try! FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
	}
	
	func readZipData(dir: URL, zipFilename: String) -> Data? {
		let fileURL = getOrCreate(dir: dir, filename: zipFilename)
		var data: Data? = nil
		if let url = fileURL as URL? {
			data = try! Data(contentsOf: url)
		}
		return data
	}
	
	func writeData(data: Data, dir: URL, to filename: String) {
		let fileURL = getOrCreate(dir: dir, filename: filename)
		let fileURLTemp = getOrCreate(dir: dir, filename: "temp_" + filename)
		
		let handlerTemp: FileHandle = try! FileHandle(forUpdating: fileURLTemp!)
		handlerTemp.write(data)
		handlerTemp.closeFile()
		
		let deleted = delete(url: fileURL!)
		if deleted {
			try! FileManager.default.moveItem(at: fileURLTemp!, to: fileURL!)
		}
	}
	
	func getOrCreate(dir: URL, subDirName: String) -> URL? {
		let url = dir.appendingPathComponent(subDirName, isDirectory: true)
		var isDirectory = ObjCBool(true)
		
		if !manager.fileExists(atPath: (url.path), isDirectory: &isDirectory) == true {
			print("\(subDirName) not exists")
			if let success = try? manager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil) {
				print("Directory created: \(success)")
			}
		}
		return url
	}
	
	func getOrCreate(dir: URL, filename: String) -> URL? {
		let url = dir.appendingPathComponent(filename)
		if !manager.fileExists(atPath: (url.path)) {
			let success = manager.createFile(atPath: (url.path), contents: nil, attributes: nil)
		}
		return url
	}
	
}
