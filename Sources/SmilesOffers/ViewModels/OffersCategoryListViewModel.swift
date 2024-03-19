//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 13/10/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities

public class OffersCategoryListViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    public enum Input {
        case getOffersCategoryList(pageNo: Int, categoryId: String, searchByLocation: Bool, sortingType: String?, subCategoryId: String, subCategoryTypeIdsList: [String]?, latitude: Double, longitude: Double, themeId:String? = nil)
    }
    
    public enum Output {
        case fetchOffersCategoryListDidSucceed(response: OffersCategoryResponseModel)
        case fetchOffersCategoryListDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
}

extension OffersCategoryListViewModel {
    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getOffersCategoryList(let pageNo, let categoryId, let searchByLocation, let sortingType, let subCategoryId, let subCategoryTypeIdsList, let latitude, let longitude, let themeId):
                self?.getOffersCategoryList(pageNo: pageNo, categoryId: categoryId, searchByLocation: searchByLocation, sortingType: sortingType, subCategoryId: subCategoryId, subCategoryTypeIdsList: subCategoryTypeIdsList, latitude:latitude, longitude:longitude, themeId: themeId)
                
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func getOffersCategoryList(pageNo: Int, categoryId: String, searchByLocation: Bool, sortingType: String?, subCategoryId: String?, subCategoryTypeIdsList: [String]?, latitude: Double, longitude: Double, themeId: String? = nil) {
        var offersCategoryRequest  : OffersCategoryRequestModel!

        if categoryId == "9"{
            offersCategoryRequest = OffersCategoryRequestModel(pageNo: pageNo, categoryId: categoryId, searchByLocation: searchByLocation, sortingType: sortingType, subCategoryId: subCategoryId, subCategoryTypeIdsList: nil, isGuestUser: AppCommonMethods.isGuestUser, categoryTypeIdsList: subCategoryTypeIdsList, latitude:latitude, longitude:longitude)
        }else {
            offersCategoryRequest = OffersCategoryRequestModel(pageNo: pageNo, categoryId: categoryId, searchByLocation: searchByLocation, sortingType: sortingType, subCategoryId: subCategoryId, subCategoryTypeIdsList: subCategoryTypeIdsList, isGuestUser: AppCommonMethods.isGuestUser, categoryTypeIdsList: nil, latitude:latitude, longitude:longitude)
        }
        
        if let themeId = themeId {
            offersCategoryRequest.themeId = "\(themeId)"
        }
        
        let service = GetOffersCategoryListRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl
        )
        
        service.getOffersCategoryListService(request: offersCategoryRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchOffersCategoryListDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.fetchOffersCategoryListDidSucceed(response: response))
            }
            .store(in: &cancellables)
    }
}



