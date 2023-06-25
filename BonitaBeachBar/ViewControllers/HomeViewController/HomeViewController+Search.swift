//
//  HomeViewController+Search.swift
//  BonitaBeachBar
//
//  Created by Stefan Brankovic on 5/30/23.
//

import UIKit

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            refreshTableViewData()
        } else {
            showSearchResults(searchText: searchText)
        }
    }
    
    func showSearchResults(searchText: String) {
        var newArray: [Any] = []
        for item in preFilteredDataSource {
            let searchTextFormatted: String = searchText.lowercased().formatSpecialCharacters()
            
            if let item = item as? User {
                
                if item.name.lowercased().contains(searchTextFormatted) {
                    newArray.append(item)
                    
                }
                else if let searchNumber = Double(searchText), let visits = item.visits {
                    for visit in visits {
                        if let total = visit.bill?.total {
                            if total >= searchNumber {
                                newArray.append(item)
                            }
                        }
                    }
                }
                else if let visits = item.visits, String(visits.count).contains(searchTextFormatted) {
                    newArray.append(item)
                    
                }
                else if let visits = item.visits {
                    for visit in visits {
                        if let billItems = visit.bill?.billItems {
                            for billItem in billItems {
                                if billItem.name.lowercased().contains(searchTextFormatted) {
                                    newArray.append(item)
                                    continue
                                }
                            }
                        }
                    }
                }
                else {
                    let words: [String] = item.name.components(separatedBy: " ")
                    for word in words {
                        if word.lowercased().contains(searchTextFormatted) {
                            newArray.append(item)
                            continue
                        }
                    }
                }
            }
            else if let item = item as? Visit {
                if item.date.contains(searchTextFormatted) {
                    newArray.append(item)
                    continue
                }
                else if let name = item.guest?.name.lowercased(),
                    name.contains(searchTextFormatted) {
                    newArray.append(item)
                    
                }
                else if let name = item.promo?.name.lowercased(),
                   name.contains(searchTextFormatted) {
                    newArray.append(item)
                    
                }
                else if let billTotal = item.bill?.total,
                        let searchNumber = Double(searchText),
                        billTotal >= searchNumber {
                    newArray.append(item)
                }
                else if let billItems = item.bill?.billItems {
                    for billItem in billItems {
                        if billItem.name.lowercased().contains(searchTextFormatted) {
                            newArray.append(item)
                            continue
                        }
                    }
                }
            }
            bonitaDataSource = newArray
            tableView.reloadData()
        }
    }
}
