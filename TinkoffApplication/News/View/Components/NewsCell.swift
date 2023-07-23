//
//  NewsCell.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//

import UIKit

final class NewsCell: UITableViewCell {
    static let cellID = "NewCell"
    
    private let gradientLayer = CAGradientLayer()
    private let containerView: UIView = {
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.layer.cornerRadius = 20
        vw.layer.borderWidth = 1
        vw.layer.borderColor = UIColor.red.cgColor
        return vw
    }()
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        return title
    }()
    private let imageArticle: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "not_found")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        return image
    }()
    private let viewCounter: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        view.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return view
    }()
    private let eyeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "eye")
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
    
    func configure(with info: NewsCellModel) {
        self.titleLabel.text = info.title
        self.viewCounter.text = "Просмотров: \(info.viewCounter) шт."
        uploadImageFromNetwork(image: info.image) { [weak self] img in
            guard let self = self, let img = img else { return }
            self.imageArticle.image = img
            self.imageArticle.contentMode = .scaleAspectFill
            self.imageArticle.layer.borderColor = UIColor.purple.cgColor
            self.imageArticle.layer.borderWidth = 1
        }
    }
    
    
}

// MARK: - Private func's.
private extension NewsCell {
    func setup() {
        setupGradient()
        [containerView, titleLabel, imageArticle, viewCounter, eyeImage].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
    
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            eyeImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            eyeImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            eyeImage.heightAnchor.constraint(equalToConstant: 20),
            eyeImage.widthAnchor.constraint(equalToConstant: 20),
            
            viewCounter.leadingAnchor.constraint(equalTo: eyeImage.leadingAnchor, constant: 25),
            viewCounter.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.5),
            viewCounter.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            imageArticle.topAnchor.constraint(equalTo: eyeImage.bottomAnchor, constant: 8),
            imageArticle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            imageArticle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            imageArticle.heightAnchor.constraint(equalToConstant: 200),
            imageArticle.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])

    }
    
    func setupGradient() {
        var colors: [UIColor] = []
        let currentTraitCollection = UITraitCollection.current
        
        /// Смотрим, какая выбрана тема экрана.
        if currentTraitCollection.userInterfaceStyle == .light {
            colors = [UIColor(red: 219/255, green: 0, blue: 255/255, alpha: 1),
                      UIColor(red: 192/255, green: 0, blue: 255/255, alpha: 1),
                      UIColor(red: 160/255, green: 0, blue: 255/255, alpha: 1)]
        } else {
            colors = [UIColor(red: 219/255, green: 0, blue: 255/255, alpha: 0.7),
                      UIColor(red: 192/255, green: 0, blue: 255/255, alpha: 0.7),
                      UIColor(red: 160/255, green: 0, blue: 255/255, alpha: 0.7)]
        }
        
        containerView.layer.addSublayer(gradientLayer)
        gradientLayer.cornerRadius = 20
        gradientLayer.colors = colors.map { $0.cgColor }
    }
}

// MARK: - Preview:
import SwiftUI
struct PreviewNewsViewControllerCell: PreviewProvider {
    /// Менять для других привью.
    typealias CurrentPreview = PreviewNewsViewControllerCell.ContainerView
    
    static var previews: some View {
        ContainerView()
            .ignoresSafeArea()
            .preferredColorScheme(.dark)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias PreviewContext = UIViewControllerRepresentableContext<CurrentPreview>
        
        func makeUIViewController(context: PreviewContext) -> some UIViewController {
            return NewsComposer.make()
        }
        
        func updateUIViewController(
            _ uiViewController: CurrentPreview.UIViewControllerType,
            context: PreviewContext) {
            }
    }
}
