//
//  File.swift
//  
//
//  Created by Habib Rehman on 16/02/2024.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities

public protocol OffersDetailUseCaseProtocol {
    func getOffersDetail(offerId: String?) -> AnyPublisher<OffersDetailUsecase.State, Never>
}
 
final public class OffersDetailUsecase: OffersDetailUseCaseProtocol {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    public init() {}
    // MARK: - getBogoOffers
    public func getOffersDetail(offerId: String?) -> AnyPublisher<OffersDetailUsecase.State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            
            let service = OffersDetailRespository(
                networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
                baseUrl: AppCommonMethods.serviceBaseUrl
            )
            let request = GetOfferDetailsRequest(offerId: offerId)
            service.getOffersDetail(request: request)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.success(.fetchOffersDetailDidFail(error: error)))
                    }
                } receiveValue: { response in
                    promise(.success(.fetchOffersDetailDidSucceed(response: response)))
                }
                .store(in: &cancellables)
                
        }
        .eraseToAnyPublisher()
        
    }
  
}
 
 
extension OffersDetailUsecase {
   public enum State {
        case fetchOffersDetailDidSucceed(response: OfferDetailsResponse)
        case fetchOffersDetailDidFail(error: NetworkError)
    }
}
