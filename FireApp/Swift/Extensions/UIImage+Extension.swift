//
//  UIImage+Extension.swift
//  FireApp
//
//  Created by boiler on 2020/12/30.
//

import UIKit

extension UIImage {
    
    func cropping(to rect: CGRect, imageViewSize: CGSize) -> UIImage? {
        
        let imageViewScale = max(self.size.width / imageViewSize.width,
                                 self.size.height / imageViewSize.height)

        let cropZone = CGRect(x: rect.origin.x * imageViewScale,
                              y: rect.origin.y * imageViewScale,
                              width: rect.size.width * imageViewScale,
                              height: rect.size.height * imageViewScale)

        guard let cutImageRef = self.cgImage?.cropping(to:cropZone) else { return nil }

        return UIImage(cgImage: cutImageRef)
    }
}
