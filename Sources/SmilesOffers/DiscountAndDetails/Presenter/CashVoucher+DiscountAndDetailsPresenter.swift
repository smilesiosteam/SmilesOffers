//
//  CashVoucher+DiscountAndDetailsPresenter.swift
//  House
//
//  Created by Hanan on 11/28/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesUtilities

extension DiscountAndDetailsPresenter {
    
    func rowModelForCashVouchers() -> BaseSectionModel {
        let rowSectionModels = BaseSectionModel()
        let voucherModel = VoucherAmountCellModel()
        var tableRowIndex = 0
        
        if var rechargeDomination = self.offersDetailResponse?.voucherDenominations, rechargeDomination.count > 0 {
            rechargeDomination = rechargeDomination.sorted(by: { $0.denominationAED ?? 0 < $1.denominationAED ?? 0 })
            self.offersDetailResponse?.voucherDenominations = rechargeDomination
            var amountRows = [BaseRowModel]()
            for (currentIndex, denomination) in rechargeDomination.enumerated() {
                if currentIndex == 5
                {
                    break
                }
                let amountModel = AmountCollectionViewCellModel()
                amountModel.amount = "\(denomination.denominationAED ?? 0)"
                amountModel.selectedIndex = currentIndex
                amountModel.tableCellIndex = tableRowIndex
                if currentIndex == 0 {
                    amountModel.isSelected = true
                    self.selectedVoucherDomination = denomination
                } else {
                    amountModel.isSelected = false
                }
                
                if currentIndex > 3 {
                    amountModel.shouldMoreCome = true
                }
                amountRows.append(DenominationAmountCell.rowModel(model: amountModel, delegate: self))
            }
            voucherModel.baseRowModels = amountRows
        }
        
        tableRowIndex += 1
        
        voucherModel.cashVoucherDescription = self.offersDetailResponse?.offerDescription
        
        if let dynamicDenomination = self.offersDetailResponse?.dynamicDenomination,  dynamicDenomination {
            voucherModel.textFieldPlaceholder = "EnterVoucherAmountAED".localizedString
            voucherModel.textFieldInteraction = true
            
            if let minVoucherDenomination = self.offersDetailResponse?.minVoucherDenomination, let maxVoucherDenomination = self.offersDetailResponse?.maxVoucherDenomination {
                voucherModel.errorColor = .appGreyColor_128
                voucherModel.errorText = String(format: "VoucherDynamicRangeWarning".localizedString, minVoucherDenomination.denominationAED ?? 0, maxVoucherDenomination.denominationAED ?? 0)
            }
        } else {
            voucherModel.textFieldPlaceholder = "SelectedVoucherTitle".localizedString
            voucherModel.errorText = ""
            voucherModel.textFieldInteraction = false
        }
        
        if let voucherDenominationAmount = self.selectedVoucherDomination?.denominationAED, voucherDenominationAmount > 0 {
            voucherModel.voucherAmount = "\(voucherDenominationAmount)"
            self.dynamicVoucherAmount = "\(voucherDenominationAmount)"
            if !voucherModel.textFieldInteraction {
                voucherModel.voucherAmount = "\(dynamicVoucherAmount ?? "") \("AED".localizedString)"
            }
            self.selectedDenomination = voucherDenominationAmount
            self.view?.enableContinueButton(true)
        }
        
        if self.isSoldOut {
            voucherModel.collectionViewInteraction = false
            self.view?.enableContinueButton(false)
        } else {
            voucherModel.collectionViewInteraction = true
            self.view?.enableContinueButton(true)
        }
        
        let cell = DiscountAndDetailsCashVoucherTableViewCell.rowModel(model: voucherModel, delegate: self)
        
        rowSectionModels.rowItems.append(cell)
        
        return rowSectionModels
    }
}

//MARK: - BillPaymentRechargeCellDelegate

extension DiscountAndDetailsPresenter: VoucherAmountCellModelDelegate {
    func forTextFieldDidBeginEditing() {
        
    }
    
    
    func textFieldDidChange(updatedValue: String?, valueChangeOn cell: DiscountAndDetailsCashVoucherTableViewCell?) {
        if let cell = cell {
            if let changedValue = updatedValue?.toDouble() {
                
                let isVaildVoucherAmount = Int(changedValue) % (self.offersDetailResponse?.incrementalDenomination ?? 0) == 0 ? true : false
                
                if let minVoucherDenomination = self.offersDetailResponse?.minVoucherDenomination, let maxVoucherDenomination = self.offersDetailResponse?.maxVoucherDenomination {
                    if changedValue < Double(minVoucherDenomination.denominationAED ?? 0) || changedValue > Double(maxVoucherDenomination.denominationAED ?? 0) {
                        cell.errorLabel.textColor = .red
                        cell.errorLabel.text = String(format: "DynamicVoucherAmountError".localizedString, minVoucherDenomination.denominationAED ?? 0, maxVoucherDenomination.denominationAED ?? 0)
                        
                        view?.enableContinueButton(false)
                        
                        self.dynamicVoucherAmount = updatedValue
                        self.totalAmount = Double(self.dynamicVoucherAmount ?? "0")
                        
                        if let previousSelectedIndex = self.selectedDenominationIndex {
                            ((self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.baseRowModels?[safe: previousSelectedIndex]?.rowValue as? AmountCollectionViewCellModel)?.isSelected = false
                        }
                                                    
                        self.selectedDenomination = nil
                        self.selectedDenominationIndex = nil
                        self.selectedVoucherDomination = nil
                        
                        (self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.voucherAmount = "\(dynamicVoucherAmount ?? "")"

                        if self.totalAmount ?? 0 > 0 {
                            let amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: self.totalAmount?.fractionDigitsRounded(to: 2) ?? ""))"
                            self.view?.updateTotalAmount(totalAmount: amountToShowOnCart, ofQuantity: self.voucherQuantity ?? 0, isVatable: self.isVatableOffer)
                        }
                        
                        self.view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)

                        return
                        
                    } else {
                        if !isVaildVoucherAmount {
                            cell.errorLabel.textColor = .red
                            cell.errorLabel.text = String(format: "DynamicVoucherAmountError".localizedString, minVoucherDenomination.denominationAED ?? 0, maxVoucherDenomination.denominationAED ?? 0)
                            view?.enableContinueButton(false)
                            self.dynamicVoucherAmount = updatedValue
                            self.totalAmount = Double(self.dynamicVoucherAmount ?? "0")
                            
                            if let previousSelectedIndex = self.selectedDenominationIndex {
                                ((self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.baseRowModels?[safe: previousSelectedIndex]?.rowValue as? AmountCollectionViewCellModel)?.isSelected = false
                            }
                                                        
                            self.selectedDenomination = nil
                            self.selectedDenominationIndex = nil
                            self.selectedVoucherDomination = nil
                            
                            (self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.voucherAmount = "\(dynamicVoucherAmount ?? "")"

                            if self.totalAmount ?? 0 > 0 {
                                let amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: self.totalAmount?.fractionDigitsRounded(to: 2) ?? ""))"
                                self.view?.updateTotalAmount(totalAmount: amountToShowOnCart, ofQuantity: self.voucherQuantity ?? 0, isVatable: self.isVatableOffer)
                            }
                            
                            self.view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)

                            return
                        } else {
                            self.dynamicVoucherAmount = updatedValue
                            view?.enableContinueButton(true)
                        }
                    }
                    
                }
                
       
                
//                self.dynamicVoucherAmount = "\(Int(changedValue))"
                
                if let denominations = self.offersDetailResponse?.voucherDenominations, !denominations.isEmpty {
                    if let firstSuchElementIndex = denominations.firstIndex(where: { $0.denominationAED?.double == changedValue }) {
                        if let previousSelectedIndex = self.selectedDenominationIndex {
                            ((self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.baseRowModels?[safe: previousSelectedIndex]?.rowValue as? AmountCollectionViewCellModel)?.isSelected = false
                        }
                        
                        self.selectedDenominationIndex = firstSuchElementIndex
                        self.selectedVoucherDomination = denominations[safe: firstSuchElementIndex]
                        
                        ((self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.baseRowModels?[safe: firstSuchElementIndex]?.rowValue as? AmountCollectionViewCellModel)?.isSelected = true
                        
                        self.dynamicVoucherAmount = "\(Int(changedValue))"
                        
                        if let dynamicDenomination = self.offersDetailResponse?.dynamicDenomination,  dynamicDenomination {
                            (self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.voucherAmount = "\(dynamicVoucherAmount ?? "")"
                        } else {
                            (self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.voucherAmount = "\(dynamicVoucherAmount ?? "") \("AED".localizedString)"
                        }
                        
                        self.totalPoints = self.selectedVoucherDomination?.denominationPoint

                        self.view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)
                    }else{
                        if let previousSelectedIndex = self.selectedDenominationIndex {
                            ((self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.baseRowModels?[safe: previousSelectedIndex]?.rowValue as? AmountCollectionViewCellModel)?.isSelected = false
                        }
                        
                        (self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.voucherAmount = "\(dynamicVoucherAmount ?? "")"
                        
//                        self.dynamicVoucherAmount = nil
                        self.selectedDenomination = nil
                        self.selectedDenominationIndex = nil
                        self.selectedVoucherDomination = nil
                    }
                }
                
                self.totalAmount = Double(self.dynamicVoucherAmount ?? "0")
                self.getPaymentInfoFromWebService()
                
                if self.totalAmount ?? 0 > 0 {
                    let amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: self.totalAmount?.fractionDigitsRounded(to: 2) ?? ""))"
                    self.view?.updateTotalAmount(totalAmount: amountToShowOnCart, ofQuantity: self.voucherQuantity ?? 0, isVatable: self.isVatableOffer)
                }
                
                self.view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)
            }
        }
    }
    
    func getPaymentInfoFromWebService() {
        self.view?.showHud()
        let request = PaymentInfoRequestModel()
        request.offerId = self.offersDetailResponse?.offerId
        request.accountType = GetEligibilityMatrixResponse.sharedInstance.accountType.asStringOrEmpty()
        request.offerType = self.offersDetailResponse?.offerType
        request.paymentItemType = Int(getPaymentTypeBasedOnOfferTypeIfEtisalatDOD(isEtisalatDOD: self.isFromEtisalatOffersSection))
        
        services.getPaymentInfo(request: request) { [weak self] paymentInfoResponse in
            self?.view?.hideHud()
            self?.calculatePointsForDynamicVoucher(paymentInfo: paymentInfoResponse)
        } failureBlock: { [weak self] error in
            self?.view?.hideHud()
        }
    }
    
    func calculatePointsForDynamicVoucher(paymentInfo: PaymentInfoResponseModel?) {
        guard let paymentRanges = paymentInfo?.paymentRanges else {
            return
        }
        
        self.totalPoints = PointsConvertor.convertAedToPoints(aedValue: self.totalAmount.asDoubleOrEmpty(), inRanges: paymentRanges)

    }
    
    func getPaymentTypeBasedOnOfferTypeIfEtisalatDOD(isEtisalatDOD: Bool) -> PaymentInfoTypes.RawValue {
        if self.offersDetailResponse?.offerType?.rawValue.lowercased() == "discount" {
            return  DISCOUNT_PAYMENT_TYPE.rawValue
        }
        else if self.offersDetailResponse?.offerType?.rawValue.lowercased() == "voucher" {
            return  VOUCHER_PAYMENT_TYPE.rawValue
        }
        else if self.offersDetailResponse?.offerType?.rawValue.lowercased() == "deal voucher" {
            return  DEALVOUCHER_PAYMENT_TYPE.rawValue
        }
        else {
            if isEtisalatDOD {
                return  ETISALATDOD_PAYMENT_TYPE.rawValue
            } else {
                return  ESERVICE_PAYMENT_TYPE.rawValue
            }
        }
    }
}


// MARK: - DenominationAmountCellDelegate

extension DiscountAndDetailsPresenter: DenominationAmountCellDelegate {
    func didSelectAmount(index: Int, tableCellIndex: Int, cell: DenominationAmountCell) {
        print(index)
        if let shouldMoreCome = ((self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.baseRowModels?[safe: index]?.rowValue as? AmountCollectionViewCellModel)?.shouldMoreCome, shouldMoreCome {
            if let voucherDenomination = self.offersDetailResponse?.voucherDenominations{
                let moreVoucherSelectionViewController = CommonMethods.getViewController(fromStoryboardName: "DiscountAndDetails", andIdentifier: "MoreVoucherSelectionViewController") as! MoreVoucherSelectionViewController
                moreVoucherSelectionViewController.selectedIndex = self.selectedDenominationIndex ?? 0
                moreVoucherSelectionViewController.voucherArray = voucherDenomination
                moreVoucherSelectionViewController.delegate = self
                router?.presentViewController(vc: moreVoucherSelectionViewController)
            }
            
            return
        }
        (self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.selectedIndex = index
        
        if let previousSelectedIndex = self.selectedDenominationIndex {
            ((self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.baseRowModels?[safe: previousSelectedIndex]?.rowValue as? AmountCollectionViewCellModel)?.isSelected = false
        }
        
        ((self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.baseRowModels?[safe: index]?.rowValue as? AmountCollectionViewCellModel)?.isSelected = true
        
        view?.enableContinueButton(true)
        
        if let selectedDenominationAmount = self.offersDetailResponse?.voucherDenominations?[safe: index]?.denominationAED {
            // Selected Denomination is the value selected and to be used
            self.selectedDenomination = selectedDenominationAmount
            self.dynamicVoucherAmount = "\(selectedDenominationAmount)"
            self.selectedDenominationIndex = index
            
            if let dynamicDenomination = self.offersDetailResponse?.dynamicDenomination,  dynamicDenomination {
                (self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.voucherAmount = "\(dynamicVoucherAmount ?? "")"
            } else {
                (self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.voucherAmount = "\(dynamicVoucherAmount ?? "") \("AED".localizedString)"
            }
        }
        self.isSelectedAmountFromList = true
        self.selectedVoucherDomination = self.offersDetailResponse?.voucherDenominations?[safe: index]
        
        self.totalAmount = self.selectedDenomination?.double
        self.totalPoints = self.selectedVoucherDomination?.denominationPoint
        
        if self.totalAmount ?? 0 > 0 {
            let amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: self.totalAmount?.fractionDigitsRounded(to: 2) ?? ""))"
            self.view?.updateTotalAmount(totalAmount: amountToShowOnCart, ofQuantity: self.voucherQuantity ?? 0, isVatable: self.isVatableOffer)
        }
        
        self.view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)
    }
    
    func didUnSelectAmount(index: Int, tableCellIndex: Int, cell: DenominationAmountCell) {
        print(index)
        self.isSelectedAmountFromList = false
    }
}

// MARK: - MoreVoucherSelectionViewControllerDelegate

extension DiscountAndDetailsPresenter: MoreVoucherSelectionViewControllerDelegate {
    func didselectWith(index: Int) {
        if let previousSelectedIndex = self.selectedDenominationIndex {
            ((self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.baseRowModels?[safe: previousSelectedIndex]?.rowValue as? AmountCollectionViewCellModel)?.isSelected = false
        }
        
        selectedDenominationIndex = index
        
        if let selectedDenominationAmount = self.offersDetailResponse?.voucherDenominations?[safe: index]?.denominationAED {
            self.selectedDenomination = selectedDenominationAmount
            self.dynamicVoucherAmount = "\(selectedDenominationAmount)"
            if let dynamicDenomination = self.offersDetailResponse?.dynamicDenomination,  dynamicDenomination {
                (self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.voucherAmount = "\(dynamicVoucherAmount ?? "")"
            } else {
                (self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.voucherAmount = "\(dynamicVoucherAmount ?? "") \("AED".localizedString)"
            }
        }
        if let selectedDenominationPoints = self.offersDetailResponse?.voucherDenominations?[safe: index]?.denominationPoint {
            self.totalPoints = selectedDenominationPoints
        }
        ((self.sectionItems[safe: 1]?.rowItems.last?.rowValue as?  VoucherAmountCellModel)?.baseRowModels?[safe: index]?.rowValue as? AmountCollectionViewCellModel)?.isSelected = true
        
        self.totalAmount = self.selectedDenomination?.double
        
        if self.totalAmount ?? 0 > 0 {
            let amountToShowOnCart = "\(AppCommonMethods.getWithAEDValue(string: self.totalAmount?.fractionDigitsRounded(to: 2) ?? ""))"
            self.view?.updateTotalAmount(totalAmount: amountToShowOnCart, ofQuantity: self.voucherQuantity ?? 0, isVatable: self.isVatableOffer)
        }
        
        self.view?.rowModelsGeneratedForDiscountAndDetails(withSectionsModels: self.sectionItems, delegate: self)
    }
    
}
