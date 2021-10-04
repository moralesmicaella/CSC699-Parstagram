//
//  TabBarController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/8/21.
//

import UIKit
import Parse
import AlamofireImage

class TabBarController: UITabBarController {
    
    var feedTab: UITabBarItem!
    var profileTab: UITabBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBar.tintColor = .black
        tabBar.selectedItem?.badgeColor = .none
        
        feedTab = tabBar.items![0]
        feedTab.image = UIImage(named: "feed_tab")
        
        profileTab = tabBar.items?[1]

        let user = PFUser.current()!
        if let imageFile = user["profile_photo"] as? PFFileObject {
            let image = Image.getImageFromFile(imageFile)
            setProfileTabImage(image)
        } else {
            let image = UIImage()
            setProfileTabImage(image)
        }
        
    }
    
    func setProfileTabImage(_ image: UIImage) {
        profileTab?.image = Image.getImage(image: image, width: 32, height: 32)
        profileTab?.selectedImage = Image.getImage(image: image, width: 32, height: 32, borderWidth: 2, borderColor: .black)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
