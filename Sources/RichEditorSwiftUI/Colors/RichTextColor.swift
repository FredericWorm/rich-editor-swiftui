//
//  RichTextColor.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

import SwiftUI

/// This enum defines supported rich text color types.
///
/// The enum makes the colors identifiable and diffable.
public enum RichTextColor: String, CaseIterable, Codable, Equatable,
    Identifiable
{

    /// Foreground color.
    case foreground

    /// Background color.
    case background

    /// Strikethrough color.
    case strikethrough

    /// Stroke color.
    case stroke

    /// Underline color.
    case underline
}

extension RichTextColor {

    /// The unique color ID.
    public var id: String { rawValue }

    /// The corresponding rich text attribute, if any.
    public var attribute: NSAttributedString.Key? {
        switch self {
        case .foreground: .foregroundColor
        case .background: .backgroundColor
        case .strikethrough: .strikethroughColor
        case .stroke: .strokeColor
        case .underline: .underlineColor
        }
    }

    /// The standard icon to use for the color.
    public var icon: Image {
        switch self {
        case .foreground: .richTextColorForeground
        case .background: .richTextColorBackground
        case .strikethrough: .richTextColorStrikethrough
        case .stroke: .richTextColorStroke
        case .underline: .richTextColorUnderline
        }
    }

    /// The localized color title key.
    public var titleKey: RTEL10n {
        switch self {
        case .foreground: .foregroundColor
        case .background: .backgroundColor
        case .strikethrough: .strikethroughColor
        case .stroke: .strokeColor
        case .underline: .underlineColor
        }
    }

    /// Adjust a `color` for a certain `colorScheme`.
    public func adjust(
        _ color: Color?,
        for scheme: ColorScheme
    ) -> Color {
        switch self {
        case .background: color ?? .clear
        default: color ?? .primary
        }
    }
}

extension Collection where Element == RichTextColor {

    public static var allCases: [RichTextColor] { Element.allCases }
}
