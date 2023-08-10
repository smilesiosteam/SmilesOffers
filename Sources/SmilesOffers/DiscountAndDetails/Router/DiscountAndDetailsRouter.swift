//
//  DiscountAndDetailsRouter.swift
//  House
//
//  Created by Shahroze Zaheer on 10/19/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation
import UIKit

@objc class DiscountAndDetailsRouter: NSObject {

    // MARK: Properties

    weak var view: UIViewController?

    // MARK: Static methods

    @objc static func setupModule() -> DiscountAndDetailsViewController {
        let viewController = DiscountAndDetailsViewController.instantiate(fromAppStoryboard: .DiscountAndDetails)
        let presenter = DiscountAndDetailsPresenter()
        let router = DiscountAndDetailsRouter()

        viewController.presenter =  presenter
        presenter.view = viewController
        presenter.router = router
        router.view = viewController

        return viewController
    }
}

extension DiscountAndDetailsRouter: DiscountAndDetailsWireframe {
    // TODO: Implement wireframe methods
    
    func navigateToViewController(viewController: UIViewController) {
        view?.navigationController?.pushViewController(viewController: viewController)
    }
    
    func presentViewController(vc: UIViewController) {
        view?.navigationController?.present(vc)
    }
    
    func presentGuestPopUp() {
        self.presentGuestLogin(vc: view)
    }
}
