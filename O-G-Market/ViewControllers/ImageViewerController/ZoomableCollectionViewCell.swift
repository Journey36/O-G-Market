//
//  ZoomableCollectionViewCell.swift
//  O-G-Market
//
//  Created by odongnamu on 2022/02/02.
//

import UIKit

class ZoomableCollectionViewCell: UICollectionViewCell {
    static let id = "ZoomableCollectionViewCell"

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1

        return scrollView
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true

        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.scrollView.delegate = self


        addSubviews()
        configureLayout()
        addDoubleTapGestureRecognizer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        self.contentView.addSubview(scrollView)
        self.scrollView.addSubview(imageView)
    }

    private func configureLayout() {
        self.scrollView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.edges.equalToSuperview()
        }

        self.imageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.edges.equalTo(self.scrollView.contentLayoutGuide)
        }
    }

    private func addDoubleTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
    }
}

// MARK: ScrollViewDelegate
extension ZoomableCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let collectionView = self.superview as? UICollectionView else { return }

        let enlarged = scrollView.zoomScale > 1
        collectionView.isScrollEnabled = !enlarged

        guard let image = self.imageView.image else { return }

        if enlarged {
            let ratioW = self.imageView.frame.width / image.size.width
            let ratioH = self.imageView.frame.height / image.size.height

            let ratio = ratioW < ratioH ? ratioW : ratioH

            let imageWidth = image.size.width * ratio
            let imageHeight = image.size.height * ratio

            let leftCondition = imageWidth * scrollView.zoomScale > self.imageView.frame.width
            var leftInset = leftCondition ? imageWidth - self.imageView.frame.width : scrollView.frame.width - scrollView.contentSize.width

            leftInset *= 0.5

            let topCondition = imageHeight * scrollView.zoomScale > self.imageView.frame.height
            var topInset = topCondition ? imageHeight - self.imageView.frame.height : scrollView.frame.height - scrollView.contentSize.height

            topInset *= 0.5

            scrollView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: topInset, right: leftInset)
        } else {
            scrollView.contentInset = .zero
        }
    }
}

// MARK: UIGestureRecognizer
extension ZoomableCollectionViewCell {
    @objc private func doubleTapped(_ recognzier: UITapGestureRecognizer) {
        if scrollView.zoomScale > 1 {
            scrollView.zoom(to: imageView.frame, animated: true)
        } else {
            let point = recognzier.location(in: imageView)
            let scrollSize = scrollView.frame.size
            let size = CGSize(width: scrollSize.width / scrollView.maximumZoomScale ,
                              height: scrollSize.height / scrollView.maximumZoomScale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)

            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        }
    }
}
