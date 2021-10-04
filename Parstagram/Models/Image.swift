//
//  Image.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/11/21.
//

import Foundation
import Parse

struct Image {
    static func getImageFromFile(_ imageFile: PFFileObject) -> UIImage {
        if let imageFileUrl = imageFile.url {
            if let imageUrl = URL(string: imageFileUrl) {
                if let imageData = NSData(contentsOf: imageUrl) as Data? {
                    return UIImage(data: imageData)!
                }
            }
        }
        return UIImage()
    }
    
    static func getImage(image: UIImage, width: CGFloat, height: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .black) -> UIImage {
        let frameWidth = width + borderWidth
        let frameHeight = height + borderWidth
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight))

        imageView.image = image
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = frameWidth / 2
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = borderColor.cgColor
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, image.scale)
        if let context = UIGraphicsGetCurrentContext() {
            imageView.layer.render(in: context)
            if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
                return newImage.withRenderingMode(.alwaysOriginal)
            }
        }

        return image
    }
}
