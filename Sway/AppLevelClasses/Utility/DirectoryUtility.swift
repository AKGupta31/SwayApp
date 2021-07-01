//
//  DirectoryUtility.swift
//  Sway
//
//  Created by Admin on 01/07/21.
//

import Foundation

enum FolderNames : String{
    case kCompressedVideos = "CompressedVideos"
}
class DirectoryUtility {
    static func getPath(folder: String) -> URL{
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let downloadsPath = documentsUrl.appendingPathComponent(folder)
        let exists = FileManager.default.fileExists(atPath: downloadsPath.path, isDirectory: nil)
        if !exists{
            do{
                try FileManager.default.createDirectory(atPath: downloadsPath.path, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("Error creating path")
            }
        }
        return downloadsPath
    }
}
