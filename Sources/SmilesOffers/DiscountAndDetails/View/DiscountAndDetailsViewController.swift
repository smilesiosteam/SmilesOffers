//
//  DiscountAndDetailsViewController.swift
//  House
//
//  Created by Shahroze Zaheer on 10/19/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation
import UIKit
import SmilesEasyTipView

@objc protocol OfferDetailsDelegate{
    func didRefreshOfferList()
}
extension DiscountAndDetailsViewController: ApplyPromoCodeViewControllerDelegate{
    func applyPromoCodeSucceedWithPromo(code: String, binBasedResponse: BinBasedDO?, bankName: String?) {
        
    }
}

class DiscountAndDetailsViewController: BaseViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var resturantName: UILabel!
    @IBOutlet weak var offerDescriptionLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cartParentView: UIView!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var voucherInfoView: UIView!
    @IBOutlet weak var getNowView: UIView!
    @IBOutlet weak var bottomShadowView: UIView! {
        didSet {
            bottomShadowView.addShadowToSelf(offset: CGSize(width: 0, height: -1), color: UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.1), radius: 1.0, opacity: 5)
        }
    }
    
    // Bottom cart view Outlets
    @IBOutlet weak var voucherCountLabel: UILabel!
    @IBOutlet weak var voucherPriceLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var getNowBtn: UIButton! {
        didSet {
            getNowBtn.setTitle("GET_NOW".localizedString.capitalizingFirstLetter(), for: .normal)
        }
    }
    @IBOutlet var view_offerType: UIView?
    @IBOutlet var lbl_offerType: UILabel?
    
    @IBOutlet weak var tableViewTopView: UIView!
    @IBOutlet weak var getNowViewButton: UIButton!
    
    // MARK: Properties
    
    var presenter: DiscountAndDetailsPresentation?
    @objc var offerID: String?
    @objc var offerType: String?
    @objc var isFromGamification:Bool = false
    @objc var luckyDealExpiryDate : String = ""
    @objc var birthDayTitle : String = ""
    @objc var birthDayRedeemedTitle:String = ""
    @objc var etisalatOfferDictionary = [String:Any]()
    @objc var isFromEtisalatOffersSection: Bool = false
    @objc var isFromNearbyOffersSection: Bool = false
    @objc var isFromDealsForYouSection: Bool = false
    var titleStringForNavBar = ""
    @objc var openDetailsFrom : String?
    var isFromDealsOfDay : Bool = false
    @objc var delegate : OfferDetailsDelegate?
    var recommendationModelEvent: String?
    var comeFromSummaryForRecommendedOffer: Bool?
    @objc var recommendationModelEventOfDealsForOffer: String?
    @objc var isTelcoOffer: Bool = false

    // MARK: Lifecycle
    
    
    
    override func viewDidLoad() {
        tableView.tableHeaderView = headerView
        DiscountAndDetailsTableViewContentOffset = .zero
        setupNavigationBar(withTitle: "", backButtonImg: "", clearHeader: true, rightSideButtons: [])
        
        if (self.isFromDealsOfDay || self.isFromGamification){
            if luckyDealExpiryDate.isEmpty {
                self.rightSideButtons = [shareBarButton]
            }
        }else{
            if luckyDealExpiryDate.isEmpty {
                self.rightSideButtons = [shareBarButton, favouriteBarButton]
            }
        }
        
        
        super.viewDidLoad()
        callOfferDetailService()
        setupUI()
        
        view_retry.isHidden = true
        view_retry.showErrorWith(errorType: .somethingWrong)
        view_retry.retryDelegate = self
        
        getNowViewButton.setTitle("", for: .normal)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @objc func callOfferDetailService() {
        presenter?.viewDidload(withofferID: offerID, type: offerType,isFromGamification: isFromGamification, luckyDealExpiryDate: luckyDealExpiryDate,birthDayTitle: birthDayTitle, birthDayRedeemedTitle: birthDayRedeemedTitle,etisalatOfferDictionary: etisalatOfferDictionary, isFromEtisalatOffersSection: isTelcoOffer, isFromNearbyOffersSection: isFromNearbyOffersSection, isFromDealsForYouSection: isFromDealsForYouSection, openDetailsFrom: openDetailsFrom, recommendationModelEvent: self.recommendationModelEvent, comeFromSummaryForRecommendedOffer: self.comeFromSummaryForRecommendedOffer, recommendationModelEventOfDealsOffer: self.recommendationModelEventOfDealsForOffer)
    }
    
    
    func setupTableViewCells() {
        tableView.registerCellFromNib(SeparatorTableViewCell.self, withIdentifier: String(describing: SeparatorTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsSoldOutTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsSoldOutTableViewCell.self))
        
        tableView.registerCellFromNib(SpeicalRaffleDaysLeftTableViewCell.self, withIdentifier: String(describing: SpeicalRaffleDaysLeftTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsRedeemedOfferTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsRedeemedOfferTableViewCell.self))
        
        tableView.registerCellFromNib(BirthdayPriceBannerTableViewCell.self, withIdentifier: String(describing: BirthdayPriceBannerTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsPriceTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsPriceTableViewCell .self))
        
        tableView.registerCellFromNib(DiscountAndDetailsOfferQuantityTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsOfferQuantityTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsSegmentTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsSegmentTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsLocationTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsLocationTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsValidityTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsValidityTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsAboutTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsAboutTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsHowItWorksTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsHowItWorksTableViewCell.self))
        
        tableView.registerCellFromNib(BogoCustomTableCell.self, withIdentifier: String(describing: BogoCustomTableCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsRelatedOffersTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsRelatedOffersTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsMapViewTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsMapViewTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsTermsAndConditionsTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsTermsAndConditionsTableViewCell.self))
        
        tableView.registerCellFromNib(CBDCreditCardBannerTableViewCell.self, withIdentifier: String(describing: CBDCreditCardBannerTableViewCell.self))
        
        tableView.registerCellFromNib(SpaceCellWithSeperator.self, withIdentifier: String(describing: SpaceCellWithSeperator.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsCashVoucherTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsCashVoucherTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsQuantityTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsQuantityTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsRamdanOfferTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsRamdanOfferTableViewCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsBulletCell.self, withIdentifier: String(describing: DiscountAndDetailsBulletCell.self))
        
        tableView.registerCellFromNib(AgreeTermsCustomCell.self, withIdentifier: String(describing: AgreeTermsCustomCell.self))
        
        tableView.registerCellFromNib(DiscountAndDetailsOrderNowTableViewCell.self, withIdentifier: String(describing: DiscountAndDetailsOrderNowTableViewCell.self))
    }
    
    func setupUI() {
        setupTableViewCells()
        viewHeader.frame = CGRect.init(x: viewHeader.frame.origin.x, y: viewHeader.frame.origin.y, width: viewHeader.frame.size.width, height: 88)
        changeNavigationBarStyleWhileScrolling(intialState: true, withTitle: "")
        
        voucherCountLabel.text = String(format: "NoOfVouchers".localizedString, 0)
        
        self.vatLabel.text = "VatIncludedTitle".localizedString
        
        self.view_offerType?.RoundedViewConrner(cornerRadius: 8)
        
        DispatchQueue.main.async {
            self.tableViewTopView.roundSpecifiCorners(corners: [.topLeft, .topRight], radius: 12)
        }
        
        self.enableContinueButton(false)
    }
    
    override func favouriteButtonAction(_ sender: UIButton?) {
        presenter?.addToFavoritesTapped()
    }
    
    override func shareBarButtonAction(_ sender: UIButton?) {
        presenter?.shareTapped()
    }
    
    private func changeNavigationBarStyleWhileScrolling(intialState: Bool, withTitle title: String) {
        DispatchQueue.main.async {
            self.setHeaderWithTitle(title)
        }
        
        backButton?.RoundedViewConrner(cornerRadius: 12.0)
        if intialState {
            viewHeader.backgroundColor = .clear
            backButton?.backgroundColor = .white
            if LanguageManager.sharedInstance().currentLanguage == Arabic {
                backButton?.setImage(UIImage(named: "BackArrow_black_Ar"), for: .normal)
            } else {
                backButton?.setImage(UIImage(assetIdentifier: .BackArrow_black), for: .normal)
            }
        }
        else {
            viewHeader.backgroundColor = .appRevampPurpleMainColor
            if LanguageManager.sharedInstance().currentLanguage == Arabic {
                backButton?.setImage(UIImage(named: "BackArrow_black_Ar"), for: .normal)
            } else {
                backButton?.setImage(UIImage(assetIdentifier: .BackArrow_black), for: .normal)
            }
        }
    }
}

extension DiscountAndDetailsViewController: DiscountAndDetailsView {
    func wishlistUpdated() {
        self.delegate?.didRefreshOfferList()
    }
    
    func reloadSection(index: Int) {
//        tableView.beginUpdates()
//        tableView.reloadSections([index], with: .automatic)
        tableView.reloadData()
//        tableView.endUpdates()
    }
    
    func indexForSegmentCell(cell: DiscountAndDetailsSegmentTableViewCell) -> IndexPath? {
        return tableView.indexPath(for: cell)
    }
    
    func reloadCellAt(index: [IndexPath]) {
        tableView.reloadRows(at: index, with: .automatic)
    }
    
    func indexForAboutCell(cell: DiscountAndDetailsAboutTableViewCell) -> IndexPath? {
        return tableView.indexPath(for: cell)
    }
    
    func indexForOfferQuantityCell(cell: DiscountAndDetailsOfferQuantityTableViewCell) -> IndexPath? {
        return tableView.indexPath(for: cell)
    }
    
    func updateTitleAndImage(offerDetail: OfferDetailsResponse)  {
        DispatchQueue.main.async {
            guard let _ = offerDetail.offerId else {
                self.sharedButton?.isHidden = true
                self.favouriteButton?.isHidden = true
                return
            }
           
            self.resturantName.text = offerDetail.partnerName ?? ""
            self.offerDescriptionLabel.text = offerDetail.offerTitle ?? ""
            self.bannerImage.setImageWithUrlString(offerDetail.offerImageUrl ?? "", defaultImage: "placeholder_banner")
            
            if let voucherPromoText = offerDetail.voucherPromoText, !voucherPromoText.isEmpty {
                self.lbl_offerType?.text = voucherPromoText
                self.view_offerType?.backgroundColor = self.presenter?.changeOfferTypeBackground(with: voucherPromoText, isPromotionalOffer: true)
            } else {
                if let offerType = offerDetail.offerType?.rawValue {
                    self.lbl_offerType?.text = offerType.uppercased()
                    self.view_offerType?.backgroundColor = self.presenter?.changeOfferTypeBackground(with: offerType, isPromotionalOffer: false)
                }
                if LanguageManager.sharedInstance().currentLanguage == Arabic {
                    self.lbl_offerType?.text = offerDetail.offerTypeAr.asStringOrEmpty()
                }
                
                if offerDetail.offerType?.rawValue.lowercased() == "Voucher".lowercased() {
                    self.lbl_offerType?.text = "CashVoucherTitle".localizedString.uppercased()
                }
            }
            // Check for Get Now button enable disable buttons
            //            self.enableContinueButton(false)  // initially disabled
            
            switch offerDetail.offerType {
            case .discount, .voucher:
                if (offerDetail.isBirthdayOffer ?? false || offerDetail.isRedeemedOffer ?? false){
                    self.sharedButton?.isHidden = true
                    self.favouriteButton?.isHidden = true
                }else{
                    self.sharedButton?.isHidden = false
                    self.favouriteButton?.isHidden = false
                }
                
                if let voucherSharingFlag = offerDetail.voucherSharingFlag, voucherSharingFlag {
                    if !self.luckyDealExpiryDate.isEmpty {
                        self.sharingIcon(shouldHide: true)
                    } else {
                        self.sharingIcon(shouldHide: false)
                    }
                } else {
                    self.sharingIcon(shouldHide: true)
                }
                
                if !(offerDetail.lifestyleSubscriberFlag ?? false && offerDetail.isBirthdayOffer ?? false) {
                    print("life style flag")
                    if let viewForTip = self.presenter?.getViewForToolTip(on: self.tableView) {
                        let toolTipText = getUserProfileResponse.sharedClient().onAppStartObjectResponse?.offersForFreeBannerToolTipText
                        
                        EasyTipViewPreference.showTip(forView: viewForTip, withInSuperView: nil, withText: toolTipText ?? "", arrowPosition: .bottom, bubbleHInset: 0) {}
                    }
                }
                
            case .dealVoucher:
                if offerDetail.eligibleFlag == ELIGABLE {
                    self.enableContinueButton(self.presenter!.isDealVoucherSelected()) // disabled if deal voucher is not selected
                } else {
                    self.enableContinueButton(true) // else true
                }
                
                if let voucherSharingFlag = offerDetail.voucherSharingFlag, voucherSharingFlag {
                    self.sharingIcon(shouldHide: false)
                } else {
                    self.sharingIcon(shouldHide: true)
                }
                
            case .etisalat:
                if offerDetail.dirhamValue == 0 {
                    self.enableContinueButton(false)
                }
                if let voucherSharingFlag = offerDetail.voucherSharingFlag, voucherSharingFlag {
                    self.sharingIcon(shouldHide: false)
                } else {
                    self.sharingIcon(shouldHide: true)
                }
            case .none:
                break
            }
        }
    }
    
    func sharingIcon(shouldHide: Bool) {
        self.sharedButton?.isHidden = shouldHide
    }
    
    // TODO: implement view output methods
    func rowModelsGeneratedForDiscountAndDetails(withSectionsModels: [BaseSectionModel], delegate: DiscountAndDetailsPresenter) {
        self.cartParentView.isHidden = false
        setUpTableViewSectionsDataSource(dataSource: withSectionsModels, delegate: delegate, tableView: self.tableView)
    }
    
    func updateFavoritesButtonIcon(isFavorite: Bool) {
        if isFavorite {
            self.favouriteButton?.setImage(UIImage(named:"favSelectedTop"), for: .normal)
        } else {
            self.favouriteButton?.setImage(UIImage(named:"favouritesImage"), for: .normal)
        }
    }
    
    func presentShareActivity(vc: UIActivityViewController?) {
        if let activityController = vc {
            
            activityController.completionWithItemsHandler = { (type, completed, items, error) in
                print("block")
                if (!completed) {return}
                self.presenter?.addEventsOnShare(with: type ?? UIActivity.ActivityType.airDrop)
            }
            
            self.present(activityController, animated: true) { () in
            }
        }
    }
    
    
    func didSelectRowAt(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func didDeSelectRowAt(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    func didScrollTableView(scrollView: UIScrollView) {
        if scrollView == tableView {
            let denominator: CGFloat = 90
            let alpha = min(1, scrollView.contentOffset.y / denominator)
            
            if alpha == 1 {
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                    self.changeNavigationBarStyleWhileScrolling(intialState: false, withTitle: self.resturantName.text ?? "")
                })
            }
            else {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
                    self.changeNavigationBarStyleWhileScrolling(intialState: true, withTitle: self.titleStringForNavBar)
                })
                
            }
        }
    }
    
    func enableContinueButton(_ enable: Bool) {
        bottomView.isUserInteractionEnabled = enable ? true : false
        bottomView.alpha = enable ? 1 : 0.5
    }
    
    func dealExpired(isExpired:Bool) {
        if isExpired{
            self.tableViewTopView.backgroundColor = UIColor(red: 190.0 / 255.0, green: 18.0 / 255.0, blue: 24.0 / 255.0, alpha: 1.0)
        }else{
            self.tableViewTopView.backgroundColor = UIColor().colorWithHexString(hexString: "EC8A23")
        }
      
    }
    
    func dealSoldOut(isSoldOut: Bool) {
        if isSoldOut {
            self.enableContinueButton(false)
            self.tableViewTopView.backgroundColor = .appYellowColor
        }
    }
    
    func luckyDeal() {
        self.sharedButton?.isHidden = true
    }
    
    func updateTotalAmount(totalAmount: String, ofQuantity totalQuantity: Int, isVatable: Bool) {
        if totalQuantity > 0 {
            voucherInfoView.isHidden = false
        } else {
            voucherInfoView.isHidden = true
        }
        voucherCountLabel.text = String(format: "NoOfVouchers".localizedString, totalQuantity)
        voucherPriceLabel.text = totalAmount
        
        if let getUserProfileResponse = getUserProfileResponse.sharedClient().onAppStartObjectResponse, let isVatable = getUserProfileResponse.isVatable , isVatable.lowercased() == .trueValue {
            var vatPercentage = getUserProfileResponse.vatPercentage ?? ""
            vatPercentage = vatPercentage + "%"
            
            vatLabel.text = String(format: "VatIncludedTitle".localizedString, vatPercentage)
        }
        self.vatLabel.isHidden = !isVatable
    }
    
    func updateNavigationTitle(title: String) {
        titleStringForNavBar = title
        self.setHeaderWithTitle(title)
    }
}

// MARK- IBActions
extension DiscountAndDetailsViewController {
    
    @IBAction func getNowAction(_ sender: UIButton) {
        presenter?.getNowAction(sender: sender)
    }
}

extension DiscountAndDetailsViewController {
    func showError(shouldHide: Bool, error: ErrorTypes, errorMsg: String?) {
        view_retry.showErrorWith(errorType: error, errorMsg: errorMsg)
        view_retry.isHidden = shouldHide
        
        if shouldHide {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
        else {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    func showCustomErrorForEpg(withErrorMsg: String) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view_retry.isHidden = false
        view_retry.showErrorWith(errorType: .customMsg, errorMsg: withErrorMsg)
    }
}

extension DiscountAndDetailsViewController: RetryViewDelegate {
    func retryButtonClicked(withErrorType: ErrorTypes) {
        print("Retry button clicked")
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.popViewController()
        view_retry.isHidden = true
    }
    
    func dismissButtonClicked() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        view_retry.isHidden = true
    }
}
