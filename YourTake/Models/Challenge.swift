//
//  Challenge.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-10-30.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class Challenge: NSObject {
    
    let image : UIImage
    let friends : [String]
    weak var owner : User?
    var submissions : [UIImage]?
    
    init(owner: User, image: UIImage, friends: [String])
    {
        self.owner = owner;
        self.image = image;
        self.friends = friends;
    }
    
    func Submit(image: UIImage)
    {
        if(submissions == nil)
        {
            submissions = [UIImage]()
        }
        self.submissions!.append(image);
    }
    
    
}
