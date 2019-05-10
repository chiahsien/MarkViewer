//
//  ThumbnailProvider.swift
//  Mark Viewer Thumbnail
//
//  Created by Nelson Dai on 2019/5/10.
//  Copyright © 2019 Nelson Tai. All rights reserved.
//

import UIKit
import QuickLook

class ThumbnailProvider: QLThumbnailProvider {
    override func provideThumbnail(for request: QLFileThumbnailRequest, _ handler: @escaping (QLThumbnailReply?, Error?) -> Void) {
        let fileURL = request.fileURL
        let maximumSize = request.maximumSize
        let drawingBlock: () -> Bool = {
            let success = ThumbnailProvider.drawThumbnail(for: fileURL, contextSize: maximumSize)
            return success
        }
        let reply = QLThumbnailReply(contextSize: maximumSize, currentContextDrawing: drawingBlock)

        handler(reply, nil)
    }
}

// MARK: - Helpers
private extension ThumbnailProvider {
    static func drawThumbnail(for fileURL: URL, contextSize: CGSize) -> Bool {
        var frame: CGRect = .zero
        frame.size = contextSize

        let document = MarkdownDocument(fileURL: fileURL)
        let openingSemaphore = DispatchSemaphore(value: 0)
        var openingSuccess = false

        let documentVC = MarkdownDocumentViewController()
        documentVC.view.frame = frame
        documentVC.view.layoutIfNeeded()
        documentVC.openDocument(document) { (success) in
            openingSuccess = success
            openingSemaphore.signal()
        }
        openingSemaphore.wait()

        guard openingSuccess else { return false }

        documentVC.view.draw(frame)

        let closingSemaphore = DispatchSemaphore(value: 0)
        documentVC.closeDocument { (_) in
            closingSemaphore.signal()
        }
        closingSemaphore.wait()

        return true
    }
}
