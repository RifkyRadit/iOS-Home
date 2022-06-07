//
//  HomeViewController.swift
//  iOS-Home-Exercise
//
//  Created by Administrator on 06/06/22.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents

protocol HomeViewControllerInput: AnyObject {
    func setDataHome(apiKey: String, city: String)
}

class HomeViewController: UIViewController {

    private var apiKey: String = ""
    private var city: String = ""
    
    private var tempCelcius: String = "" {
        didSet{
            self.celciusMDCTextfield.text = tempCelcius
        }
    }
    
    private var tempFahrenheit: String = "" {
        didSet{
            self.fahrenheitMDCTextfield.text = tempFahrenheit
        }
    }
    
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var containerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var celciusMDCTextfield: MDCFilledTextField = {
        let textfield: MDCFilledTextField = MDCFilledTextField()
        textfield.label.text = Value.titleCelcius
        textfield.sizeToFit()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var fahrenheitMDCTextfield: MDCFilledTextField = {
        let textfield: MDCFilledTextField = MDCFilledTextField()
        textfield.label.text = Value.titleFahrenheit
        textfield.sizeToFit()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        handleStateView(state: .showIndicator)
        setupView()
        setupLayout()
        viewModel.viewDidLoad(apiKey: self.apiKey, city: self.city)
        dataBind()
    }
    
    func dataBind() {
        viewModel.stateView = { state in
            DispatchQueue.main.async {
                self.handleStateView(state: state)
            }
        }
        
        viewModel.celciusValue = { value in
            DispatchQueue.main.async {
                self.tempCelcius = value
            }
        }
        
        viewModel.fahrenheitValue = { value in
            DispatchQueue.main.async {
                self.tempFahrenheit = value
            }
        }
    }

}

extension HomeViewController {
    func setupView() {
        view.backgroundColor = .white
        
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .large
        
        containerView.addSubview(celciusMDCTextfield)
        containerView.addSubview(fahrenheitMDCTextfield)
        view.addSubview(containerView)
        view.addSubview(indicatorView)
        
        setupTextField(textField: celciusMDCTextfield)
        setupTextField(textField: fahrenheitMDCTextfield)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            celciusMDCTextfield.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            celciusMDCTextfield.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            celciusMDCTextfield.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fahrenheitMDCTextfield.topAnchor.constraint(equalTo: celciusMDCTextfield.bottomAnchor, constant: 16),
            fahrenheitMDCTextfield.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            fahrenheitMDCTextfield.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            fahrenheitMDCTextfield.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
    }
    
    func setupTextField(textField: MDCFilledTextField) {
        textField.setFilledBackgroundColor(.clear, for: .normal)
        textField.setFloatingLabelColor(UIColor(red: 249/255, green: 95/255, blue: 107/255, alpha: 1), for: .normal)
        textField.setUnderlineColor(.systemGray, for: .normal)
        textField.setUnderlineColor(.systemGray, for: .editing)
    }
    
    func handleStateView(state: StateView) {
        switch state {
        case .showIndicator:
            indicatorView.startAnimating()
            indicatorView.isHidden = false
            containerView.isHidden = true
            
        case .showContent:
            indicatorView.stopAnimating()
            indicatorView.isHidden = true
            containerView.isHidden = false
            
        }
    }
}

extension HomeViewController: HomeViewControllerInput {
    func setDataHome(apiKey: String, city: String) {
        self.apiKey = apiKey
        self.city = city
    }
}
