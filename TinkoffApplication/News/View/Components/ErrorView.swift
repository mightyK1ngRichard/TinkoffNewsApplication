//
//  ErrorViewController.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//

import UIKit

protocol AnyErrorView: AnyObject {
    func didPressedUpdateButton()
}

final class ErrorView: UIView {
    
    // MARK: Dependencies
    
    weak var delegate: AnyErrorView?
    private var textError: String
    
    // MARK: Subviews
    
    private let errorView: UIView = {
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor    = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
        vw.layer.cornerRadius = 20
        return vw
    }()
    private let img: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "not_found")
        return img
    }()
    private let errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = UIColor(red: 126/255, green: 126/255, blue: 133/255, alpha: 1)
        lbl.font = .systemFont(ofSize: 12, weight: .medium)
        return lbl
    }()
    private let replyAgainLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Попробуйте ещё раз"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return lbl
    }()
    private let tryAgainButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(red: 87/255, green: 11/255, blue: 152/255, alpha: 1)
        btn.setTitle("Обновить", for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    // MARK: Init
   
    init(_ textError: String) {
        self.textError = textError
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}

// MARK: - Setup.

extension ErrorView {
    func setup() {
        errorLabel.text = textError
        addSubview(errorView)
        [img, errorLabel, replyAgainLabel, tryAgainButton].forEach { errorView.addSubview($0) }
        tryAgainButton.addTarget(self, action: #selector(pressedTryAgainButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            errorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            img.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            img.topAnchor.constraint(equalTo: errorView.topAnchor, constant: 16),
            
            replyAgainLabel.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            replyAgainLabel.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 8),
            
            errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 8),
            errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -8),
            errorLabel.topAnchor.constraint(equalTo: replyAgainLabel.bottomAnchor, constant: 8),
            
            tryAgainButton.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            tryAgainButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 8),
            tryAgainButton.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 16),
            tryAgainButton.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -16),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 40),
            tryAgainButton.bottomAnchor.constraint(equalTo: errorView.bottomAnchor, constant: -16)
        ])
    }

    @objc func pressedTryAgainButton() {
        guard let delegate = delegate else { return }
        delegate.didPressedUpdateButton()
    }
}
