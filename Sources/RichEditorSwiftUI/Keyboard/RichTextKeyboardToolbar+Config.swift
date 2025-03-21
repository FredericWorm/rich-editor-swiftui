//
//  RichTextKeyboardToolbar+Config.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 22/10/24.
//

#if os(iOS) || os(macOS) || os(visionOS)
    import SwiftUI

    /// This struct can configure a ``RichTextKeyboardToolbar``.
    public struct RichTextKeyboardToolbarConfig {

        /// Create a custom keyboard toolbar configuration.
        ///
        /// - Parameters:
        ///   - alwaysDisplayToolbar: Whether or not to always show the toolbar, by default `false`.
        ///   - leadingActions: The leading actions, by default `.undo` and `.redo`.
        ///   - trailingActions: The trailing actions, by default `.dismissKeyboard`.
        public init(
            alwaysDisplayToolbar: Bool = false,
            leadingActions: [RichTextAction] = [.undo, .redo],
            trailingActions: [RichTextAction] = [.dismissKeyboard]
        ) {
            self.alwaysDisplayToolbar = alwaysDisplayToolbar
            self.leadingActions = leadingActions
            self.trailingActions = trailingActions
        }

        /// Whether or not to always show the toolbar.
        public var alwaysDisplayToolbar: Bool

        /// The leading toolbar actions.
        public var leadingActions: [RichTextAction]

        /// The trailing toolbar actions.
        public var trailingActions: [RichTextAction]
    }

    extension RichTextKeyboardToolbarConfig {

        /// The standard rich text keyboard toolbar config.
        ///
        /// You can override this to change the global default.
        public static var standard = RichTextKeyboardToolbarConfig()
    }

    extension View {

        /// Apply a ``RichTextKeyboardToolbar`` configuration.
        public func richTextKeyboardToolbarConfig(
            _ config: RichTextKeyboardToolbarConfig
        ) -> some View {
            self.environment(\.richTextKeyboardToolbarConfig, config)
        }
    }

    extension RichTextKeyboardToolbarConfig {

        fileprivate struct Key: EnvironmentKey {

            public static var defaultValue: RichTextKeyboardToolbarConfig =
                .standard
        }
    }

    extension EnvironmentValues {

        /// This value can bind to a keyboard toolbar config.
        public var richTextKeyboardToolbarConfig: RichTextKeyboardToolbarConfig
        {
            get { self[RichTextKeyboardToolbarConfig.Key.self] }
            set { self[RichTextKeyboardToolbarConfig.Key.self] = newValue }
        }
    }
#endif
