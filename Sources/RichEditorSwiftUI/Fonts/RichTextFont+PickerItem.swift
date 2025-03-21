//
//  RichTextFont+PickerItem.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 18/11/24.
//

import SwiftUI

extension RichTextFont {

    /**
     This struct is used by the various library font pickers.
     */
    struct PickerItem: View, ListPickerItem {

        init(
            font: Item,
            fontSize: CGFloat = 20,
            isSelected: Bool
        ) {
            self.font = font
            self.fontSize = fontSize
            self.isSelected = isSelected
        }

        typealias Item = RichTextFont.PickerFont

        let font: Item
        let fontSize: CGFloat
        let isSelected: Bool

        var item: Item { font }

        var body: some View {
            HStack {
                Text(font.fontDisplayName)
                    .font(.custom(font.fontName, size: fontSize))
                Spacer()
                if isSelected {
                    checkmark
                }
            }.contentShape(Rectangle())
        }
    }
}
