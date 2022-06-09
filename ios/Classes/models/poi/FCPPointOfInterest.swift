//
//  FCPPointOfInterest.swift
//  Runner
//
//  Created by Olaf Schneider on 15.02.22.
//

import CarPlay

@available(iOS 14.0, *)
class FCPPointOfInterest {
  private(set) lazy var cpInstance: CPPointOfInterest = {
    
    let location = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
    var pinImage:UIImage? = nil;
    
    if let image = self.image { 
      pinImage = image.toUIImage()
      if let pImage = pinImage {
        if pImage.size.height > FCPPointOfInterest.maxPinImageSize  ||
            pImage.size.width > FCPPointOfInterest.maxPinImageSize {
          pinImage = pImage.resizeImageTo(size: CGSize(width:FCPPointOfInterest.maxPinImageSize,height:FCPPointOfInterest.maxPinImageSize))
        }
      }
    }
    let poi = CPPointOfInterest(location:location,title:title,subtitle: subtitle,summary:summary,
                                detailTitle:detailTitle,detailSubtitle: detailSubtitle,
                                detailSummary: detailSummary,pinImage: pinImage);
    
    if let primaryButton = self.primaryButton {
      poi.primaryButton = primaryButton.cpInstance
      
    }
    if let secondaryButton = self.secondaryButton {
      poi.secondaryButton = secondaryButton.cpInstance
    }
    return poi
  }()
  private(set) var elementId: String
  private var latitude: Double
  private var longitude: Double
  private var title:String
  private var subtitle:String?
  private var summary:String?
  private var detailTitle:String?
  private var detailSubtitle:String?
  private var detailSummary:String?
  private var image:FCPImage?
  
  private var primaryButton: FCPTextButton?
  
  private var secondaryButton: FCPTextButton?
  
  static let maxPinImageSize:CGFloat = 40
  
  init(message: FCPPointOfInterestMessage) {
    elementId = message.elementId
    latitude = message.latitude.doubleValue
    longitude = message.longitude.doubleValue
    title = message.title
    subtitle = message.subtitle
    summary = message.summary
    detailTitle = message.detailTitle
    detailSubtitle = message.detailsSubtitle
    detailSummary = message.detailSummary
    image = message.image?.toFCPImage()
    
    let primaryButtonData = message.primaryButton
    if primaryButtonData != nil {
      primaryButton = FCPTextButton(message: primaryButtonData!);
      
    }
    
    let secondaryButtonData = message.secondaryButton
    if secondaryButtonData != nil {
      secondaryButton = FCPTextButton(message: secondaryButtonData!);
    }
  }
}

@available(iOS 14.0, *)
extension FCPPointOfInterest: FCPObject {
  var children: [FCPObject] {
    return [primaryButton, secondaryButton].compactMap({$0})
  }
  
  
}
