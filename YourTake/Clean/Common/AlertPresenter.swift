//
//  AlertPresenter.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-10-14.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class AlertPresenter: NSObject {
    
    weak var viewController: UIViewController!

    func present(viewControllerToPresent: UIViewController, completion: (() -> Void)?) {
        self.viewController.present(viewControllerToPresent, animated: true, completion: completion)
    }
    
    func presentAlertAndPopToRoot(title: String?, message: String, actionTitle: String?) -> UIViewController {
        let viewControllerToPresent = presentAlert(title: title, message: message, actionTitle: actionTitle)
        let time = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            viewControllerToPresent.dismiss(animated: true, completion:{
                _ = self.viewController.navigationController?.popToRootViewController(animated: true)
            })
        })
        return viewControllerToPresent
    }
    
    func presentAlert(title: String?, message: String, actionTitle: String?) -> UIViewController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        if let actionTitle = actionTitle {
            let action = UIAlertAction(title: actionTitle,
                                       style: .default,
                                       handler: {
                                        (action: UIAlertAction!) in alert.dismiss(animated: true, completion: nil)})
            alert.addAction(action)
        }
        present(viewControllerToPresent: alert, completion: nil)
        return viewController
    }
}
