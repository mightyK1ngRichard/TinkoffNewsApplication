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
            "black" : .black,
            "bold" : .bold,
            "heavy" : .heavy,
            "light" : .light,
            "medium" : .medium,
            "regular" : .regular,
            "semibold" : .semibold,
            "thin" : .thin,
            "ultraLight" : .ultraLight,
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
