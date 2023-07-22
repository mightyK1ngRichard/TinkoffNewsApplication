//
//  NewsDetailViewController.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//

import UIKit

final class NewsDetailViewController: UIViewController {
    
    // MARK: Dependencies

    private let presenter: NewsPresenterInput
    
    // MARK: Subviews
    
    private let container: UIView = {
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        scroll.alwaysBounceHorizontal = false
        return scroll
    }()
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.font = .systemFont(ofSize: 22, weight: .black)
        return title
    }()
    private let newsImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "not_found")
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.clipsToBounds = true
        return img
    }()
    private let newsDescription: UILabel = {
        let desc = UILabel()
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font = UIFont.systemFont(ofSize: 17)
        desc.numberOfLines = 0
        return desc
    }()
    private let newsPublicDate: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.numberOfLines = 1
        date.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        date.textColor = UIColor.gray
        return date
    }()
    private let newsSource: UILabel = {
        let src = UILabel()
        src.translatesAutoresizingMaskIntoConstraints = false
        src.font = UIFont.systemFont(ofSize: 15)
        return src
    }()
    private let newsURL: UILabel = {
        let newsUrl = UILabel()
        newsUrl.translatesAutoresizingMaskIntoConstraints = false
        newsUrl.numberOfLines = 0
        return newsUrl
    }()
    
    // MARK: Properties
    
    private var newsModel: NewsDetailModel? = nil
    
    // MARK: Init
    
    init(_ viewModel: NewsDetailModel, presenter: NewsPresenterInput) {
        self.newsModel = viewModel
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension NewsDetailViewController {
    
    // MARK: Setup
    
    func setup() {
        view.backgroundColor = UITraitCollection.current.userInterfaceStyle == .light ? UIColor.white : UIColor.black
        guard let newsModel = newsModel else { return }
        view.addSubview(scrollView)
        
        [container,
         titleLabel,
         newsPublicDate,
         newsDescription,
         newsImage,
         newsSource,
         newsURL].forEach { scrollView.addSubview($0) }
        
        /// Заполняем модельку.
        titleLabel.text = newsModel.title
        newsDescription.text = newsModel.description
        newsPublicDate.text = convertDateFromStringToCorrectString(for: newsModel.publishedAt) ?? "Дата публикации отсутствует"
        installationHighlightSource()
        installationLinkToArticle()
        uploadImageFromNetwork(image: newsModel.urlToImage) { [weak self] img in
            guard let img = img, let self = self else { return }
            self.newsImage.image = img
            self.newsImage.contentMode = .scaleAspectFill
        }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            newsPublicDate.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            newsPublicDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            newsPublicDate.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            newsImage.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            newsImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newsImage.topAnchor.constraint(equalTo: newsPublicDate.bottomAnchor, constant: 8),
            newsImage.heightAnchor.constraint(equalToConstant: 200),
            
            newsDescription.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            newsDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            newsDescription.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 16),
            
            newsSource.topAnchor.constraint(equalTo: newsDescription.bottomAnchor, constant: 16),
            newsSource.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            newsSource.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
    }
    
    func installationHighlightSource() {
        /* Функция для выделения слова 'источник' жирным шрифтом */
        guard let newsModel = newsModel else { return }
        
        let sourceName = newsModel.sourceName ?? "Не указан"
        let attributedString = NSMutableAttributedString(string: "Источник: \(sourceName)")
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: newsSource.font.pointSize, weight: .bold)
        ]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: 9))
        newsSource.attributedText = attributedString
    }
    
    func installationLinkToArticle() {
        /* Кастомизация текста ссылки */
        
        guard let newsModel = newsModel else { return }
        
        if let url = newsModel.url {
            let linkAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.blue,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            
            let attributedString = NSAttributedString(string: "\(url)",
                                                      attributes: linkAttributes)
            newsURL.attributedText = attributedString
            let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                              action: #selector(didLinkTap(_:)))
            newsURL.isUserInteractionEnabled = true
            newsURL.addGestureRecognizer(tapGestureRecognizer)
            
            /// Ставим констреинты для ссылки, если ссылка на статью есть.
            newsURL.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8).isActive = true
            newsURL.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
            newsURL.topAnchor.constraint(equalTo: newsSource.bottomAnchor, constant: 8).isActive = true
            newsURL.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12).isActive = true
            
        } else {
            /// Если нету ссылки на источник, то низ будет имя источника.
            newsSource.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12).isActive = true
        }
    }

    // MARK: Actions:
    
    @objc func didLinkTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let newsModel = newsModel, let url = newsModel.url else {
            return
        }
        
        // TODO: Сделать переход по ссылке.
        print(url)
    }

}

// MARK: - Preview:

import SwiftUI
struct PreviewNewsDetailViewController: PreviewProvider {
    /// Менять для других привью.
    typealias CurrentPreview = PreviewNewsDetailViewController.ContainerView
    
    static var previews: some View {
        ContainerView()
            .ignoresSafeArea()
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias PreviewContext = UIViewControllerRepresentableContext<CurrentPreview>

        func makeUIViewController(context: PreviewContext) -> some UIViewController {
            let interactor = NewsInteractor()
            let router = NewsRouter()
            let model = NewsFlowModel()
            let presenter = NewsPresenter(
                interactor: interactor,
                router: router,
                model: model
            )
            let viewController = NewsDetailViewController(testInfoData, presenter: presenter)
            router.viewController = viewController
            
            return viewController
        }
        
        func updateUIViewController(
            _ uiViewController: CurrentPreview.UIViewControllerType,
            context: PreviewContext) {
        }
    }
}

// MARK: - Данные для вёрстки.

let test = Articles(
    title: "WhatsApp makes it easier to send messages to unsaved numbers",
    description: "Every app has one flaw that is baffling in how unnecessarily complicated it is. For WhatsApp, that has always been the fact that you can only message people after first saving their contact. But the frustrating extra step is finally gone: A WhatsApp update is…Every app has one flaw that is baffling in how unnecessarily complicated it is. For WhatsApp, that has always been the fact that you can only message people after first saving their contact. But the frustrating extra step is finally gone: A WhatsApp update is Every app has one flaw that is baffling in how unnecessarily complicated it is. For WhatsApp, that has always been the fact that you can only message people after first saving their contact. But the frustrating extra step is finally gone: A WhatsApp update is…",
    url: "https://www.engadget.com/whatsapp-makes-it-easier-to-send-messages-to-unsaved-numbers-093511724.html",
    urlToImage: "https://s.yimg.com/uu/api/res/1.2/JFrcoFjrBRllvF8Z7y6ETg--~B/Zmk9ZmlsbDtoPTYzMDtweW9mZj0wO3c9MTIwMDthcHBpZD15dGFjaHlvbg--/https://media.zenfs.com/en/reuters.com/03c084f4fcef33110f6d89320da04a26.cf.jpg",
    publishedAt: "2023-07-20T09:35:11Z",
    source: Source( id: "Applesfera.com", name: "Engadget")
)

let testInfoData = NewsDetailModel(
    title: test.title,
    description: test.description,
    url: URL(string: test.url!),
//    url: nil,
    urlToImage: URL(string: test.urlToImage!),
    publishedAt: test.publishedAt,
    sourceName: test.source.name
//    sourceName: nil
)
