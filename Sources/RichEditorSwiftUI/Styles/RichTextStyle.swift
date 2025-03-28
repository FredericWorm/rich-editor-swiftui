//
//  RichTextStyle.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 22/11/24.
//

import SwiftUI

public enum RichTextStyle: String, CaseIterable, Identifiable,
  RichTextLabelValue
{

  case bold
  case italic
  case underline
  case strikethrough
}

extension RichTextStyle {

  /// All available rich text styles.
  public static var all: [Self] { allCases }
}

extension Collection where Element == RichTextStyle {

  /// All available rich text styles.
  public static var all: [RichTextStyle] { RichTextStyle.allCases }
}

extension RichTextStyle {

  public var id: String { rawValue }

  /// The standard icon to use for the trait.
  public var icon: Image {
    switch self {
    case .bold: .richTextStyleBold
    case .italic: .richTextStyleItalic
    case .strikethrough: .richTextStyleStrikethrough
    case .underline: .richTextStyleUnderline
    }
  }

  /// The localized style title.
  public var title: String {
    titleKey.text
  }

  /// The localized style title key.
  public var titleKey: RTEL10n {
    switch self {
    case .bold: .styleBold
    case .italic: .styleItalic
    case .underline: .styleUnderlined
    case .strikethrough: .styleStrikethrough
    }
  }

  /**
     Get the rich text styles that are enabled in a provided
     set of traits and attributes.

     - Parameters:
       - traits: The symbolic traits to inspect.
       - attributes: The rich text attributes to inspect.
     */
  public static func styles(
    in traits: FontTraitsRepresentable?,
    attributes: RichTextAttributes?
  ) -> [RichTextStyle] {
    var styles = traits?.enabledRichTextStyles ?? []
    if attributes?.isStrikethrough == true { styles.append(.strikethrough) }
    if attributes?.isUnderlined == true { styles.append(.underline) }
    return styles
  }
}

extension Collection where Element == RichTextStyle {

  /// Check if the collection contains a certain style.
  public func hasStyle(_ style: RichTextStyle) -> Bool {
    contains(style)
  }

  /// Check if a certain style change should be applied.
  public func shouldAddOrRemove(
    _ style: RichTextStyle,
    _ newValue: Bool
  ) -> Bool {
    let shouldAdd = newValue && !hasStyle(style)
    let shouldRemove = !newValue && hasStyle(style)
    return shouldAdd || shouldRemove
  }
}

#if canImport(UIKit)
  extension RichTextStyle {

    /// The symbolic font traits for the style, if any.
    public var symbolicTraits: UIFontDescriptor.SymbolicTraits? {
      switch self {
      case .bold: .traitBold
      case .italic: .traitItalic
      case .strikethrough: nil
      case .underline: nil
      }
    }
  }
#endif

#if os(macOS)
  extension RichTextStyle {

    /// The symbolic font traits for the trait, if any.
    public var symbolicTraits: NSFontDescriptor.SymbolicTraits? {
      switch self {
      case .bold: .bold
      case .italic: .italic
      case .strikethrough: nil
      case .underline: nil
      }
    }
  }
#endif

extension RichTextStyle {
  var richTextSpanStyle: RichTextSpanStyle {
    switch self {
    case .bold: .bold
    case .italic: .italic
    case .strikethrough: .strikethrough
    case .underline: .underline
    }
  }
}
