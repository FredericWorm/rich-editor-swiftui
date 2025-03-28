//
//  RichTextAlignment.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import SwiftUI

/// This enum defines supported rich text alignments, like left,
/// right, center, and justified.
public enum RichTextAlignment: String, CaseIterable, Codable, Equatable,
    Identifiable, RichTextLabelValue
{

    /**
     Initialize a rich text alignment with a native alignment.

     - Parameters:
     - alignment: The native alignment to use.
     */
    public init(_ alignment: NSTextAlignment) {
        switch alignment {
        case .left: self = .left
        case .right: self = .right
        case .center: self = .center
        case .justified: self = .justify
        default: self = .left
        }
    }

    /// Left text alignment.
    case left

    /// Center text alignment.
    case center

    /// Justified text alignment.
    case justify

    /// Right text alignment.
    case right
}

extension RichTextAlignment {
    public func getTextSpanStyle() -> RichTextSpanStyle {
        return .align(self)
    }
}

extension Collection where Element == RichTextAlignment {

    public static var all: [Element] { RichTextAlignment.allCases }
}

extension RichTextAlignment {

    /// The unique alignment ID.
    public var id: String { rawValue }

    /// The standard icon to use for the alignment.
    public var icon: Image { nativeAlignment.icon }

    /// The standard title to use for the alignment.
    public var title: String { nativeAlignment.title }

    /// The standard title key to use for the alignment.
    public var titleKey: RTEL10n { nativeAlignment.titleKey }

    /// The native alignment of the alignment.
    public var nativeAlignment: NSTextAlignment {
        switch self {
        case .left: .left
        case .right: .right
        case .center: .center
        case .justify: .justified
        }
    }
}

extension NSTextAlignment: RichTextLabelValue {}

extension NSTextAlignment {

    /// The standard icon to use for the alignment.
    public var icon: Image {
        switch self {
        case .left: .richTextAlignmentLeft
        case .right: .richTextAlignmentRight
        case .center: .richTextAlignmentCenter
        case .justified: .richTextAlignmentJustified
        default: .richTextAlignmentLeft
        }
    }

    /// The standard title to use for the alignment.
    public var title: String {
        titleKey.text
    }

    /// The standard title key to use for the alignment.
    public var titleKey: RTEL10n {
        switch self {
        case .left: .textAlignmentLeft
        case .right: .textAlignmentRight
        case .center: .textAlignmentCentered
        case .justified: .textAlignmentJustified
        default: .textAlignmentLeft
        }
    }
}
