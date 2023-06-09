//
//  AppDataSource.swift
//  i270-locksafe
//
//  Created by Tam Le on 13/04/2023.
//

import RxDataSources

func getInAppDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<Void, IAPProduct>> {
    return RxTableViewSectionedReloadDataSource<SectionModel<Void, IAPProduct>>(
        configureCell: {
            (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let freeTrialDays = item.skProduct.introductoryPrice?.subscriptionPeriod.numberOfUnits ?? 0
            if (freeTrialDays != 0) {
                return tableView.dequeueReuseable(ofType: TrialInAppCell.self, indexPath: indexPath).apply {
                    $0.configure(item)
                }
            } else {
                return tableView.dequeueReuseable(ofType: NormalInAppCell.self, indexPath: indexPath).apply {
                    $0.configure(item)
                }
            }
    })
}

func getPostDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<Void, ItemOrAd<Post>>> {
    return RxTableViewSectionedReloadDataSource<SectionModel<Void, ItemOrAd<Post>>>(
        configureCell: {
            (dataSource, tableView, indexPath, item) -> UITableViewCell in
            
            switch item {
            case .item(let item):
                return tableView.dequeueReuseable(ofType: DemoCell.self, indexPath: indexPath).apply {
                    $0.configureCell(item )
                    if indexPath.row % 2 == 0 {
                        $0.contentView.backgroundColor = "colorPrimary".toUIColor()
                    } else {
                        $0.contentView.backgroundColor = "colorPrimaryDark".toUIColor()
                    }
                }
            case .ad(let ad, _):
                return tableView.dequeueReuseable(ofType: MediumNativeTableViewCell.self, indexPath: indexPath).apply {
                    $0.configure(with: ad)
                }
            }
    })
}
