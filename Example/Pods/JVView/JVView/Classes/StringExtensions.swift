public extension String {
    var contentTypeJVButton: ContentTypeJVButton {
        get {
            return ContentTypeJVButton.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeJVButtonGrow: ContentTypeJVButtonGrow {
        get {
            return ContentTypeJVButtonGrow.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeJVLabel: ContentTypeJVLabel {
        get {
            return ContentTypeJVLabel.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeJVLabelText: ContentTypeJVLabelText {
        get {
            return ContentTypeJVLabelText.getContentType(contentTypeId: self) as! ContentTypeJVLabelText
        }
    }
    
    var contentTypeTextFont: ContentTypeTextFont {
        get {
            return ContentTypeTextFont.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeJVLabelAttributedText: ContentTypeJVLabelAttributedText {
        get {
            return ContentTypeJVLabelAttributedText.getContentType(contentTypeId: self) as! ContentTypeJVLabelAttributedText
        }
    }
    
    var contentTypeAttributedText: ContentTypeAttributedText {
        get {
            return ContentTypeAttributedText.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeJVLabelCountingLabel: ContentTypeJVLabelCountingLabel {
        get {
            return ContentTypeJVLabelCountingLabel.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeJVLabelTextCountingLabel: ContentTypeJVLabelTextCountingLabel {
        get {
            return ContentTypeJVLabelTextCountingLabel.getContentType(contentTypeId: self) as! ContentTypeJVLabelTextCountingLabel
        }
    }
    
    var contentTypeTextView: ContentTypeTextView {
        return ContentTypeTextView.getContentType(contentTypeId: self)
    }
}
