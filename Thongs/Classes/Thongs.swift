import Foundation

public enum Thongs {

    public typealias Composer = (NSAttributedString) -> NSAttributedString

    public static func string(_ string: String) -> NSAttributedString {
        return NSAttributedString(string: string)
        
    }

    public static func font(_ font: UIFont) -> Composer {
        return { attributedString in
            let s = attributedString.mutableCopy() as! NSMutableAttributedString
            s.beginEditing()
            s.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedString.length))
            s.endEditing()
            return s
        }
    }

    public static func color(_ color: UIColor) -> Composer {
        return { attributedString in
            let s = attributedString.mutableCopy() as! NSMutableAttributedString
            s.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, attributedString.length))
            return s
        }
    }

    public static func kerning(_ kerning: Double) -> Composer {
        return { attributedString in
            let s = attributedString.mutableCopy() as! NSMutableAttributedString
            s.addAttribute(NSAttributedString.Key.kern, value: kerning, range: NSMakeRange(0, attributedString.length))
            return s
        }
    }

    public static func underline(_ color: UIColor, style: NSUnderlineStyle) -> Composer {
        return { attributedString in
            let s = attributedString.mutableCopy() as! NSMutableAttributedString
            s.addAttribute(NSAttributedString.Key.underlineColor, value: color, range: NSMakeRange(0, attributedString.length))
            s.addAttribute(NSAttributedString.Key.underlineStyle, value: style.rawValue, range: NSMakeRange(0, attributedString.length))
            return s
        }
    }

    public static func strikethrough(_ color: UIColor, style: NSUnderlineStyle) -> Composer {
        return { attributedString in
            let s = attributedString.mutableCopy() as! NSMutableAttributedString
            s.addAttribute(NSAttributedString.Key.strikethroughColor, value: color, range: NSMakeRange(0, attributedString.length))
            s.addAttribute(NSAttributedString.Key.strikethroughStyle, value: style.rawValue, range: NSMakeRange(0, attributedString.length))
            return s
        }
    }

    public static func concat(_ comp1: NSAttributedString) -> Composer {
        return { comp2 in
            let s = comp1.mutableCopy() as! NSMutableAttributedString
            s.append(comp2)
            return s
        }
    }
}
// Operators

precedencegroup LiftPrecedence {
    associativity: left
    higherThan: ConcatenationPrecedence
}

infix operator ~~> : LiftPrecedence

public func ~~> (composer: @escaping Thongs.Composer, text: String) -> NSAttributedString {
    return { composer(Thongs.string(text)) }()
}


precedencegroup CompositionPrecedence {
    associativity: left
    higherThan: LiftPrecedence
}

infix operator <*> : CompositionPrecedence

public func <*> (composer1: @escaping Thongs.Composer, composer2: @escaping Thongs.Composer) -> Thongs.Composer {
    return { str in
        composer2(composer1(str))
    }
}


//concat(a)(b)

precedencegroup ConcatenationPrecedence {
    associativity: right
    higherThan: AssignmentPrecedence
}

infix operator <+> : ConcatenationPrecedence

public func <+> (text1: NSAttributedString, text2: NSAttributedString) -> NSAttributedString {
    return Thongs.concat(text1)(text2)
}
