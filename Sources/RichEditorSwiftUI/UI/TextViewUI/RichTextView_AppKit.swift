//
//  File.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 19/10/24.
//

#if os(macOS)
  import AppKit

  /// This is a platform-agnostic rich text view that can be used
  /// in both UIKit and AppKit.
  ///
  /// The view inherits `NSTextView` in AppKit and `UITextView`
  /// in UIKit. It aims to make these views behave more alike and
  /// make them implement ``RichTextViewComponent``, which is the
  /// protocol that is used within this library.
  ///
  /// The view will apply a ``RichTextImageConfiguration/disabled``
  /// image config by default. You can change this by setting the
  /// property manually or by using a ``RichTextDataFormat`` that
  /// supports images.
  open class RichTextView: NSTextView, RichTextViewComponent {

    // MARK: - Properties

    /// The configuration to use by the rich text view.
    public var configuration: Configuration = .standard

    /// The theme for coloring and setting style to text view.
    public var theme: Theme = .standard {
      didSet { setup(theme) }
    }

    /// The style to use when highlighting text in the view.
    public var highlightingStyle: RichTextHighlightingStyle = .standard

    /// The image configuration to use by the rich text view.
    //    public var imageConfiguration: RichTextImageConfiguration = .disabled

    // MARK: - Overrides

    /// Paste the current pasteboard content into the view.
    open override func paste(_ sender: Any?) {
      //        let pasteboard = NSPasteboard.general
      //        if let image = pasteboard.image {
      //            return pasteImage(image, at: selectedRange.location)
      //        }
      super.paste(sender)
    }

    /**
     Try to perform a certain drag operation, which will get
     and paste images from the drag info into the text.
     */
    //    open override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
    //        let pasteboard = draggingInfo.draggingPasteboard
    //        if let images = pasteboard.images, images.count > 0 {
    //            pasteImages(images, at: selectedRange().location, moveCursorToPastedContent: true)
    //            return true
    //        }
    //        // Handle fileURLs that contain known image types
    //        let images = pasteboard.pasteboardItems?.compactMap {
    //            if let str = $0.string(forType: NSPasteboard.PasteboardType.fileURL),
    //               let url = URL(string: str), let image = ImageRepresentable(contentsOf: url) {
    //                let fileExtension = url.pathExtension.lowercased()
    //                let imageExtensions = ["jpg", "jpeg", "png", "gif", "tiff", "bmp", "heic"]
    //                if imageExtensions.contains(fileExtension) {
    //                    return image
    //                }
    //            }
    //            return nil
    //        } ?? [ImageRepresentable]()
    //        if images.count > 0 {
    //            pasteImages(images, at: selectedRange().location, moveCursorToPastedContent: true)
    //            return true
    //        }
    //
    //        return super.performDragOperation(draggingInfo)
    //    }

    open override func scrollWheel(with event: NSEvent) {

      if configuration.isScrollingEnabled {
        return super.scrollWheel(with: event)
      }

      // 1st nextResponder is NSClipView
      // 2nd nextResponder is NSScrollView
      // 3rd nextResponder is NSResponder SwiftUIPlatformViewHost
      self.nextResponder?
        .nextResponder?
        .nextResponder?
        .scrollWheel(with: event)
    }

    // MARK: - Setup

    /**
     Setup the rich text view with a rich text and a certain
     ``RichTextDataFormat``.

     - Parameters:
     - text: The text to edit with the text view.
     - format: The rich text format to edit.
     */
    open func setup(
      with text: NSAttributedString,
      format: RichTextDataFormat?
    ) {
      setupSharedBehavior(with: text, format)
      allowsImageEditing = true
      allowsUndo = true
      layoutManager?.defaultAttachmentScaling =
        NSImageScaling.scaleProportionallyDown
      isContinuousSpellCheckingEnabled =
        configuration.isContinuousSpellCheckingEnabled
      setup(theme)
    }

    public func setup(with richText: RichText) {
      var tempSpans: [RichTextSpanInternal] = []
      var text = ""
      richText.spans.forEach({
        let span = RichTextSpanInternal(
          from: text.utf16Length,
          to: (text.utf16Length + $0.insert.utf16Length - 1),
          attributes: $0.attributes)
        tempSpans.append(span)
        text += $0.insert
      })

      let str = NSMutableAttributedString(string: text)

      tempSpans.forEach { span in
        str.addAttributes(
          span.attributes?.toAttributes(font: .standardRichTextFont)
            ?? [:], range: span.spanRange)
      }

      setup(with: str, format: .archivedData)
    }

    // MARK: - Open Functionality

    /**
     Alert a certain title and message.

     - Parameters:
     - title: The alert title.
     - message: The alert message.
     - buttonTitle: The alert button title.
     */
    open func alert(title: String, message: String, buttonTitle: String) {
      let alert = NSAlert()
      alert.messageText = title
      alert.informativeText = message
      alert.alertStyle = NSAlert.Style.warning
      alert.addButton(withTitle: buttonTitle)
      alert.runModal()
    }

    /// Copy the current selection.
    open func copySelection() {
      let pasteboard = NSPasteboard.general
      let range = safeRange(for: selectedRange)
      let text = richText(at: range)
      pasteboard.clearContents()
      pasteboard.setString(text.string, forType: .string)
    }

    /// Try to redo the latest undone change.
    open func redoLatestChange() {
      undoManager?.redo()
    }

    /// Scroll to a certain range.
    open func scroll(to range: NSRange) {
      scrollRangeToVisible(range)
    }

    /// Set the rich text in the text view.
    open func setRichText(_ text: NSAttributedString) {
      attributedString = text
    }

    /// Undo the latest change.
    open func undoLatestChange() {
      undoManager?.undo()
    }
  }

  // MARK: - Public Extensions

  extension RichTextView {

    /// The text view's layout manager, if any.
    public var layoutManagerWrapper: NSLayoutManager? {
      layoutManager
    }

    /// The spacing between the text view edges and its text.
    public var textContentInset: CGSize {
      get { textContainerInset }
      set { textContainerInset = newValue }
    }

    /// The text view's text storage, if any.
    public var textStorageWrapper: NSTextStorage? {
      textStorage
    }
  }

  // MARK: - RichTextProvider

  extension RichTextView {

    /// Get the rich text that is managed by the view.
    public var attributedString: NSAttributedString {
      get { attributedString() }
      set { textStorage?.setAttributedString(newValue) }
    }

    /// Whether or not the text view is the first responder.
    public var isFirstResponder: Bool {
      window?.firstResponder == self
    }
  }

  // MARK: - RichTextWriter

  extension RichTextView {

    // Get the rich text that is managed by the view.
    public var mutableAttributedString: NSMutableAttributedString? {
      textStorage
    }
  }

  // MARK: - Additional Pasteboard Types

  extension RichTextView {
    public override var readablePasteboardTypes: [NSPasteboard.PasteboardType] {
      var pasteboardTypes = super.readablePasteboardTypes
      pasteboardTypes.append(.png)
      return pasteboardTypes
    }
  }

  extension RichTextView {
    var textString: String {
      return self.string
    }
  }

#endif
