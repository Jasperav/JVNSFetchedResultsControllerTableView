open class JVFontUtils {
    
    public static func determineHeight(font: UIFont, text: String) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return (text as NSString).size(withAttributes: fontAttributes).height
    }
    
    public static func determineWidth(font: UIFont, text: String) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return (text as NSString).size(withAttributes: fontAttributes).width
    }
    
    public static func determineMaxHeight(fonts: [UIFont], texts: [String]) -> CGFloat {
        return determineMaxWidthAndHeight(fonts: fonts, texts: texts).height
    }
    
    public static func determineMaxWidth(fonts: [UIFont], texts: [String]) -> CGFloat {
        return determineMaxWidthAndHeight(fonts: fonts, texts: texts).width
    }
    
    public static func determineMaxWidthAndHeight(fonts: [UIFont], texts: [String]) -> (width: CGFloat, height: CGFloat) {
        assert(fonts.count == texts.count)
        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for i in 0..<fonts.count {
            maxWidth = max(maxWidth, determineWidth(font: fonts[i], text: texts[i]))
            maxHeight = max(maxHeight, determineHeight(font: fonts[i], text: texts[i]))
        }
        
        return (width: maxWidth, height: maxHeight)
    }
    
}
