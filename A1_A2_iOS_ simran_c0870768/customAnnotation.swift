//
//  customAnnotation.swift
//  A1_A2_iOS_ simran_c0870768
//
//  Created by simran mehra on 2023-01-20.
//

import Foundation
import MapKit
class customAnnotation: MKAnnotationView {
    var label: UILabel?

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
      super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
  }
