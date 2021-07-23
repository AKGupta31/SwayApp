//
//  ChallengeLibraryViewModel.swift
//  Sway
//
//  Created by Admin on 13/07/21.
//

import UIKit

protocol LibraryListingVMDelegate:BaseVMDelegate {
    func reloadLibrary()
    func reloadFilters()
}

class LibraryListingViewModel :NSObject{
    
    var searchStr = ""
    var currentPage = 1
    var PAGE_LIMIT = 10
    var canFetchMoreData = true
    weak var delegate:LibraryListingVMDelegate?
    
    var libraryItems:[LibraryItemModel]!
    var allFilters:[FilterModel]!
    
    
    var numberOfItems:Int {
        return libraryItems.count
    }

    var isFiltersOrSearchApplied:Bool{
        let selectedFilters = allFilters.filter({$0.isSelected})
        if selectedFilters.count > 0 {
            return true
        }
        if searchStr.isEmpty == false {
            return true
        }
        return false
    }
    
    init(delegate:LibraryListingVMDelegate?) {
        super.init()
        self.delegate = delegate
        libraryItems = [LibraryItemModel]()
        allFilters = [FilterModel]()
        DispatchQueue.global(qos: .background).async {
            self.getFilters()
            self.getMoreLibarayItems(isRefreshData: false)
        }
    }
    
    private func getMoreLibarayItems(isRefreshData:Bool){
        ChallengesEndPoint.getLibraryListing(page: currentPage, limit: PAGE_LIMIT,searchStr:self.searchStr, filters: self.allFilters.filter({$0.isSelected})) { [weak self](response) in
            if response.statusCode >= 200 && response.statusCode < 300 {
                if isRefreshData {
                    self?.libraryItems.removeAll()
                }
                if let items = response.data?.libraryItems {
                    self?.libraryItems.append(contentsOf: items)
                }
                if let nextHit = response.data?.next_hit{
                    self?.canFetchMoreData = nextHit >= 1
                }
                DispatchQueue.main.async {
                    self?.delegate?.reloadLibrary()
                }
                
            }else {
                self?.delegate?.showAlert(with: Constants.Messages.kError, message: response.message ?? Constants.Messages.kUnknownError)
            }
        } failure: { [weak self](status) in
            self?.delegate?.showAlert(with: Constants.Messages.kError, message: status.msg)
        }
    }
    
    func getFilters(){
        ChallengesEndPoint.getFilters {[weak self] (response) in
            if response.statusCode >= 200 && response.statusCode < 300 {
                self?.allFilters.removeAll()
                if let filters = response.data?.filters {
                    self?.allFilters.append(contentsOf: filters)
                }
                DispatchQueue.main.async {
                    self?.delegate?.reloadFilters()
                }
            }
        } failure: { (statusCode) in
            
        }
        
    }
    
    func libraryItemViewModel(at index:Int) -> LibraryItemVM{
        return LibraryItemVM(libraryItem: libraryItems[index])
    }

    
    func refreshData(){
        currentPage = 1
        getMoreLibarayItems(isRefreshData: true)
    }
    
    func loadMoreData(){
        if canFetchMoreData {
            currentPage += 1
            getMoreLibarayItems(isRefreshData: false)
        }
    }
    
}

extension LibraryListingViewModel:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        (self.delegate as? BaseViewController)?.showLoader()
        self.searchStr = textField.text ?? ""
        getMoreLibarayItems(isRefreshData: true)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (self.delegate as? BaseViewController)?.showLoader()
        self.searchStr = ""
        refreshData()
        return true
    }
    
   
    
}

class LibraryItemVM {
    private let model:LibraryItemModel
    
    init(libraryItem:LibraryItemModel) {
        self.model = libraryItem
    }

    var id:String?{
        return model._id
    }
    
    var videoThumb:URL? {
        if let urlStr = model.imageUrl?.url {
            return URL(string: urlStr)
        }
        return nil
    }
    
    var isAdded:Bool {
        return model.isAddedInMyLibrary ?? false
    }
    var name:String {
        return model.name ?? ""
    }
    
    var durationInMinutes:String {
        let durationInSeconds = model.duration ?? 0
        let minutesOfDuration =  Int(floor(Double(durationInSeconds / 60)))
        let pendingSeconds =  durationInSeconds % 60
        
        return String(format: "%02d", minutesOfDuration) + ":" + String(format: "%02d", pendingSeconds)
    }
}
