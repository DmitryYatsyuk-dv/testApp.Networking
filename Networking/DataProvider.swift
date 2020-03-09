//
//  DataProvider.swift
//  Networking
//
//  Created by Lucky on 08/03/2020.
//  Copyright © 2020 DmitriyYatsyuk. All rights reserved.
//

import UIKit

class DataProvider: NSObject {
    
    private var downloadTask: URLSessionDownloadTask!
    
    var fileLocation: ((URL) -> ())?
    var onProgress: ((Double) -> ())?
    
    private lazy var bgSession: URLSession = {
        
        let config = URLSessionConfiguration.background(withIdentifier: "ru.yatsyuk.dev@mail.Networking")
        config.isDiscretionary = true   // The system will start the task at the optimal time( default: False )
        config.timeoutIntervalForResource = 300     // Network timeout in seconds
        config.waitsForConnectivity = true      // Waiting for a network connection( default: True)
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func startDownload() {
        
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
            downloadTask = bgSession.downloadTask(with: url)
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3)
            downloadTask.countOfBytesClientExpectsToSend = 512
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        }
    }
    
    func stopDownload() {
        
        downloadTask.cancel()
    }
}

extension DataProvider: URLSessionDelegate {
    
    // Иackground download completion
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.bgSessionCompetionHandler
                else { return }
            
            appDelegate.bgSessionCompetionHandler = nil
            completionHandler()
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        print("Did finish downloading \(location.absoluteString)")
        
        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }
    
    // Showing the progress of the download
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Download progress: \(progress)")
        
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}

//  Reconnect
extension DataProvider: URLSessionTaskDelegate {
    
    // Waiting for a connection, updating the interface and more
    
    
}



