//
//  RichTextPdfDataReader.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 26/11/24.
//

import Foundation

/// This protocol extends ``RichTextReader`` with functionality
/// for generating PDF data for the current rich text.
///
/// The protocol is implemented by `NSAttributedString` as well
/// as other types in the library.
@preconcurrency @MainActor
public protocol RichTextPdfDataReader: RichTextReader {}

extension NSAttributedString: RichTextPdfDataReader {}

extension RichTextPdfDataReader {

  /**
     Generate PDF data from the current rich text.

     This is currently only supported on iOS and macOS. When
     calling this function on other platforms, it will throw
     a ``PdfDataError/unsupportedPlatform`` error.
     */
  public func richTextPdfData(configuration: PdfPageConfiguration = .standard)
    throws -> Data
  {
    #if os(iOS) || os(visionOS)
      try richText.iosPdfData(for: configuration)
    #elseif os(macOS)
      try richText.macosPdfData(for: configuration)
    #else
      throw PdfDataError.unsupportedPlatform
    #endif
  }
}

#if os(macOS)
  import AppKit

  @MainActor
  extension NSAttributedString {

    fileprivate func macosPdfData(for configuration: PdfPageConfiguration)
      throws -> Data
    {
      do {
        let fileUrl = try macosPdfFileUrl()
        let printInfo = try macosPdfPrintInfo(
          for: configuration,
          fileUrl: fileUrl)

        let scrollView = NSTextView.scrollableTextView()
        scrollView.frame = configuration.paperRect
        let textView =
          scrollView.documentView as? NSTextView ?? NSTextView()
        sleepToPrepareTextView()
        textView.textStorage?.setAttributedString(self)

        let printOperation = NSPrintOperation(
          view: textView, printInfo: printInfo)
        printOperation.showsPrintPanel = false
        printOperation.showsProgressPanel = false
        printOperation.run()

        return try Data(contentsOf: fileUrl)
      } catch {
        throw (error)
      }
    }

    fileprivate func macosPdfFileUrl() throws -> URL {
      let manager = FileManager.default
      let cacheUrl = try manager.url(
        for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil,
        create: true)
      return
        cacheUrl
        .appendingPathComponent(UUID().uuidString)
        .appendingPathExtension("pdf")
    }

    fileprivate func macosPdfPrintInfo(
      for configuration: PdfPageConfiguration,
      fileUrl: URL
    ) throws -> NSPrintInfo {
      let printOpts: [NSPrintInfo.AttributeKey: Any] = [
        .jobDisposition: NSPrintInfo.JobDisposition.save,
        .jobSavingURL: fileUrl,
      ]
      let printInfo = NSPrintInfo(dictionary: printOpts)
      printInfo.horizontalPagination = .fit
      printInfo.verticalPagination = .automatic
      printInfo.topMargin = configuration.pageMargins.top
      printInfo.leftMargin = configuration.pageMargins.left
      printInfo.rightMargin = configuration.pageMargins.right
      printInfo.bottomMargin = configuration.pageMargins.bottom
      printInfo.isHorizontallyCentered = false
      printInfo.isVerticallyCentered = false
      return printInfo
    }

    fileprivate func sleepToPrepareTextView() {
      Thread.sleep(forTimeInterval: 0.1)
    }
  }
#endif

#if os(iOS) || os(visionOS)
  import UIKit

  @MainActor
  extension NSAttributedString {

    fileprivate func iosPdfData(for configuration: PdfPageConfiguration)
      throws -> Data
    {
      let pageRenderer = iosPdfPageRenderer(for: configuration)
      let paperRect = configuration.paperRect
      let pdfData = NSMutableData()
      UIGraphicsBeginPDFContextToData(pdfData, paperRect, nil)
      let range = NSRange(location: 0, length: pageRenderer.numberOfPages)
      pageRenderer.prepare(forDrawingPages: range)
      let bounds = UIGraphicsGetPDFContextBounds()
      for i in 0..<pageRenderer.numberOfPages {
        UIGraphicsBeginPDFPage()
        pageRenderer.drawPage(at: i, in: bounds)
      }
      UIGraphicsEndPDFContext()
      return pdfData as Data
    }

    fileprivate func iosPdfPageRenderer(
      for configuration: PdfPageConfiguration
    ) -> UIPrintPageRenderer {
      let printFormatter = UISimpleTextPrintFormatter(
        attributedText: self)
      let paperRect = NSValue(cgRect: configuration.paperRect)
      let printableRect = NSValue(cgRect: configuration.printableRect)
      let pageRenderer = UIPrintPageRenderer()
      pageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
      pageRenderer.setValue(paperRect, forKey: "paperRect")
      pageRenderer.setValue(printableRect, forKey: "printableRect")
      return pageRenderer
    }
  }
#endif
