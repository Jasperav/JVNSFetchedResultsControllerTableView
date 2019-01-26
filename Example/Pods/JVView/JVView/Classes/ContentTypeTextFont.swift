import UIKit
import JVCurrentDevice
import JVContentType

public struct ContentTypeTextFont: ContentType {
    public static var allTypes = Set<ContentTypeTextFont>()
    
    private static let fakeLocalizedTextToGetCurrentFontHeight = Locale.current.localizedString(forRegionCode: "en") ?? "Test"
    
    public var contentTypeId: String?
    
    public var font: UIFont {
        didSet {
            pseudoHeight = ContentTypeTextFont.getPseudoHeight(font: font)
        }
    }
    
    public var color: UIColor
    public var pseudoHeight: CGFloat
    
    /// Initialize with system font
    public init(contentTypeId: String?, weight: UIFont.Weight, size: CGFloat, color: UIColor) {
        self.contentTypeId = contentTypeId
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        self.pseudoHeight = ContentTypeTextFont.getPseudoHeight(font: self.font)
        self.color = color
    }
    
    /// Initialize with custom font
    public init(contentTypeId: String?, fontName: String, size: CGFloat, color: UIColor) {
        self.contentTypeId = contentTypeId
        self.font = UIFont.init(name: fontName, size: size)!
        self.pseudoHeight = ContentTypeTextFont.getPseudoHeight(font: self.font)
        self.color = color
    }
    
    private static func getPseudoHeight(font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return (fakeLocalizedTextToGetCurrentFontHeight as NSString).size(withAttributes: fontAttributes).height
    }
    
    public func changeColor(_ color: UIColor) -> ContentTypeTextFont {
        var _copy = copy()
        
        _copy.color = color
        
        return _copy
    }
}
