//
//  TimeTableViewCell.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 28.04.2021.
//

import UIKit

protocol TimeTableViewCellProtocol: AnyObject {
    func reloadCollectionView()
    func display(list: [ThreeHoursWeatherModelList])
    var completionHandler: ((Int) -> Void)? { get set }
}

final class TimeTableViewCell: UITableViewCell {

    @IBOutlet private var collectionView: UICollectionView!
    private var threHoursList: [ThreeHoursWeatherModelList] = []
    var completionHandler: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        collectionView.backgroundColor = UIColor(hexString: StringValues.lightHexColor)
        setupCollection()
    }
    
    private func setupCollection() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TimeCollectionViewCell.self)
    }
    
    private func configurateTimeCell(cell: TimeCollectionViewCell, indexPath: IndexPath) {
        cell.configurateCell(weatherList: threHoursList, indexPath: indexPath)
    }
}

extension TimeTableViewCell: TimeTableViewCellProtocol {
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func display(list: [ThreeHoursWeatherModelList]) {
        self.threHoursList = list
    }
}

extension TimeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return threHoursList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.create(TimeCollectionViewCell.self, indexPath)
        configurateTimeCell(cell: cell, indexPath: indexPath)
        return cell
    }
}

extension TimeTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        completionHandler?(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SizeStructure.timeCellWidth, height: SizeStructure.timeCellHeight)
    }
}
