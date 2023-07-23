//
//  TempViewController.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//

import UIKit

class FontsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let styles: [String : UIFont.Weight] = [
            "просто текст black" : .black,
            "просто текст bold" : .bold,
            "просто текст heavy" : .heavy,
            "просто текст light" : .light,
            "просто текст medium" : .medium,
            "просто текст regular" : .regular,
            "просто текст semibold" : .semibold,
            "просто текст thin" : .thin,
            "просто текст ultraLight" : .ultraLight,
        ]
        
        var counter = 0
        styles.forEach { style in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            label.tintColor = .black
            label.text = "\(style.key)"
            label.font = .systemFont(ofSize: 18, weight: style.value)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(counter * 25)),
                label.heightAnchor.constraint(equalToConstant: 30)
            ])
            counter += 1
        }
    }

}

// MARK: - Preview:

import SwiftUI
struct PreviewTempViewController: PreviewProvider {
    /// Менять для других привью.
    typealias CurrentPreview = PreviewTempViewController.ContainerView
    
    static var previews: some View {
        ContainerView()
            .ignoresSafeArea()
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias PreviewContext = UIViewControllerRepresentableContext<CurrentPreview>

        func makeUIViewController(context: PreviewContext) -> some UIViewController {
            return FontsViewController()
        }
        
        func updateUIViewController(
            _ uiViewController: CurrentPreview.UIViewControllerType,
            context: PreviewContext) {
        }
    }
}
