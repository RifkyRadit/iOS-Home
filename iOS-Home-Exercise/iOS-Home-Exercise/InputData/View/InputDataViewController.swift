//
//  InputDataViewController.swift
//  iOS-Home-Exercise
//
//  Created by Administrator on 06/06/22.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents

class InputDataViewController: UIViewController {
    
    lazy var transparantView = UIView()
    lazy var tableView = UITableView()
    private var cityDataSource = [Value.kualaLumpur, Value.singapore, Value.indonesia]
    private var selectedTextField = UITextField()
    
    lazy var containerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var apiKeyMDCTextfield: MDCFilledTextField = {
        let textfield: MDCFilledTextField = MDCFilledTextField()
        textfield.label.text = Value.titleApiKey
        textfield.sizeToFit()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var cityMDCTextfield: MDCFilledTextField = {
        let textfield: MDCFilledTextField = MDCFilledTextField()
        textfield.label.text = Value.titleCity
        textfield.sizeToFit()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var submitMDCButton: MDCButton = {
        let button: MDCButton = MDCButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupLayout()
    }

}

extension InputDataViewController {
    func setupView() {
        view.backgroundColor = .white
        
        containerView.addSubview(apiKeyMDCTextfield)
        containerView.addSubview(cityMDCTextfield)
        containerView.addSubview(submitMDCButton)
        view.addSubview(containerView)
        
        apiKeyMDCTextfield.setFilledBackgroundColor(.clear, for: .normal)
        apiKeyMDCTextfield.setFilledBackgroundColor(.clear, for: .editing)
        apiKeyMDCTextfield.setFloatingLabelColor(UIColor(red: 249/255, green: 95/255, blue: 107/255, alpha: 1), for: .normal)
        apiKeyMDCTextfield.text = Value.apiKey
        apiKeyMDCTextfield.setUnderlineColor(.systemGray, for: .normal)
        apiKeyMDCTextfield.setUnderlineColor(.systemGray, for: .editing)
        
        cityMDCTextfield.setFilledBackgroundColor(.clear, for: .normal)
        cityMDCTextfield.setFilledBackgroundColor(.clear, for: .editing)
        cityMDCTextfield.setFloatingLabelColor(UIColor(red: 249/255, green: 95/255, blue: 107/255, alpha: 1), for: .normal)
        cityMDCTextfield.text = Value.indonesia
        cityMDCTextfield.setUnderlineColor(.systemGray, for: .normal)
        cityMDCTextfield.setUnderlineColor(.systemGray, for: .editing)
        cityMDCTextfield.delegate = self
        
        submitMDCButton.setTitle(Value.titleSubmitButton, for: .normal)
        submitMDCButton.setBackgroundColor(UIColor(red: 249/255, green: 95/255, blue: 107/255, alpha: 1), for: .normal)
        submitMDCButton.setTitleFont(.boldSystemFont(ofSize: 16), for: .normal)
        submitMDCButton.addTarget(self, action: #selector(actionSubmitButton(_:)), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            apiKeyMDCTextfield.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            apiKeyMDCTextfield.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            apiKeyMDCTextfield.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cityMDCTextfield.topAnchor.constraint(equalTo: apiKeyMDCTextfield.bottomAnchor, constant: 16),
            cityMDCTextfield.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cityMDCTextfield.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            submitMDCButton.topAnchor.constraint(equalTo: cityMDCTextfield.bottomAnchor, constant: 16),
            submitMDCButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            submitMDCButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            submitMDCButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            submitMDCButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc
    func actionSubmitButton(_ sender: UIButton) {
        var apiKey = ""
        var city = ""
        
        if let apiKeyValue = apiKeyMDCTextfield.text, !apiKeyValue.isEmpty, let cityValue = cityMDCTextfield.text, !cityValue.isEmpty {
            apiKey = apiKeyValue
            city = cityValue
        } else {
            apiKey = Value.apiKey
            city = Value.indonesia
        }
        
        let homeViewController = HomeViewController()
        homeViewController.setDataHome(apiKey: apiKey, city: city)
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
}

extension InputDataViewController {
    func addTransparantView(frames: CGRect) {
        let window = getKeyWindow()
        transparantView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparantView)
        
        tableView.frame = CGRect(x: self.containerView.frame.origin.x, y: self.containerView.frame.origin.y + frames.origin.y + frames.height, width: frames.size.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 0
        
        transparantView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparantView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparantView))
        transparantView.addGestureRecognizer(tapGesture)
        transparantView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparantView.alpha = 0.5
            self.tableView.frame = CGRect(x: self.containerView.frame.origin.x, y: self.containerView.frame.origin.y + frames.origin.y + frames.height, width: frames.size.width, height: CGFloat(self.cityDataSource.count * 50))
        }, completion: nil)
    }
    
    @objc
    func removeTransparantView() {
        let frame = selectedTextField.frame
        cityMDCTextfield.endEditing(true)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparantView.alpha = 0
            self.tableView.frame = CGRect(x: self.containerView.frame.origin.x, y: self.containerView.frame.origin.y + frame.origin.y + frame.height, width: frame.width, height: 0)
        }, completion: nil)
    }
    
    func getKeyWindow() -> UIWindow? {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return keyWindow
    }
}

extension InputDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CityCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CityCell else {
            return UITableViewCell()
        }
        
        cell.cityLabel.text = cityDataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityMDCTextfield.text = cityDataSource[indexPath.row]
        cityMDCTextfield.endEditing(true)
        removeTransparantView()
    }
}

extension InputDataViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = cityMDCTextfield
        addTransparantView(frames: cityMDCTextfield.frame)
    }
}
