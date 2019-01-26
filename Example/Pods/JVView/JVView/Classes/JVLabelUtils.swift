import JVFontUtils

open class JVLabelUtils {
    
    public static func dynamicInit(contentType: ContentTypeJVLabel) -> JVLabel {
        if contentType is ContentTypeJVLabelTextCountingLabel || contentType is ContentTypeJVLabelAttributedTextCountingLabel {
            return JVLabelCounter(contentType: contentType)
        } else {
            return JVLabel(contentType: contentType)
        }
    }
}
