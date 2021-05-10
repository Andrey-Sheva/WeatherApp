//
//  TimeTableViewCell.swift
//  WeatherApp
//
//  Created by Андрей Шевчук on 28.04.2021.
//

import UIKit

protocol TimeTableViewCellProtocol: class {
    func reloadCollectionView()
    func display(list: [ThreeHoursWeatherModelList])
    var complitionHandler: ((Int) -> Void)? {get set}
}

final class TimeTableViewCell: UITableViewCell {

    @IBOutlet private var collectionView: UICollectionView!
    private var threHoursList: [ThreeHoursWeatherModelList] = []
    var complitionHandler: ((Int) -> Void)?
    
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
        let time = threHoursList[indexPath.row].dtTxt?.components(separatedBy: " ")
        cell.display(time: time?.last)
        cell.display(temp: "\(Int(threHoursList[indexPath.item].main?.temp ?? 0) - 273) °C")
        cell.display(image: threHoursList[indexPath.item].weather?.first?.icon)
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
        complitionHandler?(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 170)
    }
}
