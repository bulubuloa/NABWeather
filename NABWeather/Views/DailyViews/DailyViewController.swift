//
//  DailyViewController.swift
//  NABWeather
//
//  Created by Omnimobile on 1/26/22.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class DailyViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    let viewModel = DailyViewModel()
    
    override func setupUI() {
        tableView.register(UINib(nibName: ViewConstants.DailyTableViewCellNib, bundle: nil), forCellReuseIdentifier: ViewConstants.DailyTableViewCellIden)
        navigationController?.title = "Weather Forecast"
    }
    
    override func setupBinding() {
        let parameterRelay = BehaviorRelay<String?>(value: nil)
        
        searchBar.rx.searchButtonClicked
            .asObservable()
            .map { [weak self] item in return self?.searchBar.text }
            .bind(to: parameterRelay)
            .disposed(by: disposeBag)
                
        let input = DailyViewModel.Input(searchParameters: parameterRelay)
        let output = viewModel.makeBinding(input: input)
        
        output.results
            .bind(to: tableView.rx.items(cellIdentifier: ViewConstants.DailyTableViewCellIden, cellType: DailyTableViewCell.self)) {
                row, element, cell in
                
                let date = "Date: \(Utils.formatDate().string(from: Utils.epoch2Date(element.dt)))"
                let avg = "Average Temperature: \(((element.temp.max + element.temp.min)/2).wrapInt())°C"
                let pressure = "Pressure: \(element.pressure)"
                let humidity = "Humidity: \(element.humidity)%"
                let description = "Description: \(element.weather.map { x in x.description }.joined(separator: ","))"
                
                if element.weather.count > 0 {
                    let iconUrl = WeatherAPIConstants.WeatherAPIIcon + element.weather[0].icon + ".png"
                    cell.imgView.kf.setImage(with: URL(string: iconUrl))
                }
                
                cell.lbDate.text = date
                cell.lbAvg.text = avg
                cell.lbPressure.text = pressure
                cell.lbHumidty.text = humidity
                cell.lbDescription.text = description
                
            }
            .disposed(by: disposeBag)
        
        output.errors
            .asObservable()
            .subscribe(
                onNext: {
                    error in
                    //do something
                    print("Error => \(error)")
                })
            .disposed(by: disposeBag)
        
        output.loading
            .asObservable()
            .subscribe(
                onNext: {
                    loadingState in
                    //do something
                })
            .disposed(by: disposeBag)
        
        output.flagFromCache
            .asObservable()
            .subscribe(
                onNext: {
                    fromCache in
                    //do something
                    print("fromCache => \(fromCache)")
                })
            .disposed(by: disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
