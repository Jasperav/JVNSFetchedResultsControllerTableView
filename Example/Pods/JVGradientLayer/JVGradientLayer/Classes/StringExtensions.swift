public extension String {
    var contentTypeStarGradientLayer: ContentTypeJVGradientLayer {
        return ContentTypeJVGradientLayer.getContentType(contentTypeId: self)
    }
    
    var contentTypesStarGradientLayer: [ContentTypeJVGradientLayer] {
        return ContentTypeJVGradientLayer.getContentTypes(contentTypeGroupId: self)
    }
    
    var contentTypeStarGradientLayerPoint: ContentTypeJVGradientLayerPoint {
        return ContentTypeJVGradientLayerPoint.getContentType(contentTypeId: self)
    }
}
