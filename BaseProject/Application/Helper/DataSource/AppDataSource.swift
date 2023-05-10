//
//  AppDataSource.swift
//  i270-locksafe
//
//  Created by Tam Le on 13/04/2023.
//

import RxDataSources

protocol AppDataSource {
    func getInAppDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<Void, IAPProduct>>
    func getPostDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<Void, ItemOrAd<Post>>>
}
