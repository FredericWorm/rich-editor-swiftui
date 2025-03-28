//
//  RichTextAttributes+RichTextStyle.swift
//
//
//  Created by Divyesh Vekariya on 28/12/23.
//

import Foundation

extension RichTextAttributes {
    /**
     Whether or not the attributes has a strikethrough style.
     */
    public var isStrikethrough: Bool {
        get { self[.strikethroughStyle] as? Int == 1 }
        set { self[.strikethroughStyle] = newValue ? 1 : 0 }
    }

    /**
     Whether or not the attributes has an underline style.
     */
    public var isUnderlined: Bool {
        get { self[.underlineStyle] as? Int == 1 }
        set { self[.underlineStyle] = newValue ? 1 : 0 }
    }
}
