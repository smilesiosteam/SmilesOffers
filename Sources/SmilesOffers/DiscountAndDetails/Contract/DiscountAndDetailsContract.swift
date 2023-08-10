//
//  DiscountAndDetailsContract.swift
//  House
//
//  Created by Shahroze Zaheer on 10/19/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation
import UIKit
import SmilesUtilities

protocol DiscountAndDetailsView: ViperView {
    // TODO: Declare view methods
    func rowModelsGeneratedForDiscountAndDetails(withSectionsModels: [BaseSectionModel], delegate: DiscountAndDetailsPresenter)
    func didSelectRowAt(indexPath: IndexPath)
    func didDeSelectRowAt(indexPath: IndexPath)
    func didScrollTableView(scrollView : UIScrollView)
    func indexForAboutCell(cell: DiscountAndDetailsAboutTableViewCell) -> IndexPath?
    func indexForSegmentCell(cell: DiscountAndDetailsSegmentTableViewCell) -> IndexPath?
    func reloadCellAt(index: [IndexPath])
    func reloadSection(index: Int)
    func enableContinueButton(_ enable: Bool)
    func presentShareActivity(vc:UIActivityViewController?)
    func updateFavoritesButtonIcon(isFavorite: Bool)
    func updateTotalAmount(totalAmount: String, ofQuantity totalQuantity: Int, isVatable: Bool)
    func updateTitleAndImage(offerDetail : OfferDetailsResponse)
    func indexForOfferQuantityCell(cell: DiscountAndDetailsOfferQuantityTableViewCell) -> IndexPath?
    func updateNavigationTitle(title: String)
    func showError(shouldHide: Bool, error: ErrorTypes, errorMsg: String?)
    func showCustomErrorForEpg(withErrorMsg:String)
    func wishlistUpdated()
    func dealExpired(isExpired:Bool)
    func dealSoldOut(isSoldOut:Bool)
    func luckyDeal() 
}

protocol DiscountAndDetailsPresentation: ViperPresenter {
    // TODO: Declare presentation methods
    func viewDidload(withofferID offerID: String?, type offerType: String?, isFromGamification:Bool,luckyDealExpiryDate: String,birthDayTitle : String, birthDayRedeemedTitle:String, etisalatOfferDictionary: [String:Any], isFromEtisalatOffersSection: Bool, isFromNearbyOffersSection: Bool, isFromDealsForYouSection: Bool, openDetailsFrom : String?, recommendationModelEvent: String?, comeFromSummaryForRecommendedOffer: Bool?, recommendationModelEventOfDealsOffer: String?)
    func addToFavoritesTapped()
    func shareTapped()
    func addEventsOnShare(with activityType: UIActivity.ActivityType)
    func changeOfferTypeBackground(with offerType: String?, isPromotionalOffer: Bool) -> UIColor?
    func isDealVoucherSelected() -> Bool
    func getNowAction(sender: UIButton)
    func getViewForToolTip(on tableView: UITableView) -> UIView?
}

protocol DiscountAndDetailsWireframe: ViperRouter {
    // TODO: Declare wireframe methods
    func navigateToViewController(viewController: UIViewController)
    func presentViewController(vc: UIViewController)
    func presentGuestPopUp()
}
