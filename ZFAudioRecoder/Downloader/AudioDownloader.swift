//
//  AudioDownloader.swift
//  ZFAudioRecoder
//
//  Created by 周正飞 on 2017/12/15.
//  Copyright © 2017年 周正飞. All rights reserved.
//

import UIKit
fileprivate let KdownloadedPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
fileprivate let KdownloadingPath = NSTemporaryDirectory()
typealias SuccessBlock = (_ filePath: String) -> ()
class AudioDownloader: NSObject, URLSessionDownloadDelegate {
   

    fileprivate lazy var session: URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)

    fileprivate lazy var dataTask: URLSessionDownloadTask = URLSessionDownloadTask()
    fileprivate lazy var outputStream: OutputStream = OutputStream()

    fileprivate var downloadingPath = ""
    fileprivate var downloadedPath = ""
    fileprivate var successDownload: SuccessBlock?
    override init() {
        
    }
    
}


extension AudioDownloader {
    
    func download(_ url: URL, _ successFilepath: SuccessBlock? = nil) {
        
        let filename = url.lastPathComponent
        downloadedPath = KdownloadedPath + "/" + filename
        downloadingPath = KdownloadingPath + "/" + filename
        self.successDownload = successFilepath
        if  ZFFileTool.fileIsExist(downloadedPath) {
            // 告诉外界文件已经下载过 待补充
            successDownload?(downloadedPath)
            return
        }
        downloadUrl(url)
        
    }
    
    
    fileprivate func downloadUrl(_ url: URL) {
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 0)

        request.setValue("bytes=\(0)-", forHTTPHeaderField: "Range")
        // 创建一个session 分配一个dataTask任务, 默认情况属于挂起状态
        dataTask = session.downloadTask(with: request)
        dataTask.resume()
        
    }
}

extension AudioDownloader {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

            outputStream = OutputStream(toFileAtPath: self.downloadingPath, append: true)!
            outputStream.open()
            completionHandler(.allow)

        }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) { // 下载完毕
        try?FileManager.default.copyItem(at: location, to: URL(fileURLWithPath: downloadedPath))
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil {
            self.successDownload?(downloadedPath)
        }
    }
}
