//
//  FontRepresentable.swift
//
//
//  Created by Divyesh Vekariya on 28/12/23.
//

#if canImport(UIKit)
    import UIKit

    /// This typealias bridges platform-specific fonts, to simplify
    /// multi-platform support.
    public typealias FontRepresentable = UIFont
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
    import AppKit

    /// This typealias bridges platform-specific fonts, to simplify
    /// multi-platform support.
    public typealias FontRepresentable = NSFont
#endif

extension FontRepresentable {

    /**
     The standard font to use for rich text.

     You can change this value to affect all types that make
     use of the value.
     */
    public static var standardRichTextFont = systemFont(
        ofSize: .standardRichTextFontSize)

    /// Create a new font by toggling a certain style.
    public func toggling(
        _ style: RichTextStyle
    ) -> FontRepresentable? {
        .init(
            descriptor: fontDescriptor.byTogglingStyle(style),
            size: pointSize
        )
    }
}
