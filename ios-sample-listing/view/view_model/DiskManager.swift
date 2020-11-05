//
//  DiskManager.swift
//  ios-sample-listing
//
//  Created by Meng on 05/11/2020.
//  Copyright © 2020 Meng. All rights reserved.
//

import Foundation

class DiskManager {
	
	var tag = "--DiskManager"
	
	static let instance = DiskManager()
	var recipes: [Recipe] = []
	
	private init() {}
	
	func deleteItem(diskPath: String, name:String) -> Bool {
		let documentDir = FileHelper.instance.documentDir
		let fileDir = FileHelper.instance.getOrCreate(dir: documentDir!, subDirName: diskPath)
		let files = FileHelper.instance.listDirIn(directoryURL: fileDir!)
		
		guard let fs = files else {
			return false
		}
		
		for file in fs {
			if file.lastPathComponent.starts(with: name) {
				return FileHelper.instance.delete(url: file)
			}
		}
		return false
	}
	
	func save(list: [Recipe]?, diskPath: String) {
		
		guard let ls = list else {
			return
		}
		
		let documentDir = FileHelper.instance.documentDir
		
		let encoder = JSONEncoder()
		let data = try! encoder.encode(ls)
		
		let url = documentDir?.appendingPathComponent(diskPath)
		let _ = FileHelper.instance.delete(url: url!)
		FileHelper.instance.writeData(data: data, dir: documentDir!, to: "\(diskPath)")
		
	}
	
	func load(diskPath: String) -> [Recipe] {
		let documentDir = FileHelper.instance.documentDir
		let data = FileHelper.instance.readZipData(dir: documentDir!, zipFilename: "\(diskPath)")
		
		let decoder = JSONDecoder()
		let result: [Recipe]? = try? decoder.decode([Recipe].self, from: data!)
		return result ?? []
	}
}
