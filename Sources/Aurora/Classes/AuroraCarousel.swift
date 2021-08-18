//
//  File.swift
//  
//
//  Created by Wesley de Groot on 30/07/2021.
//

import Foundation
#if canImport(UIKit)
import UIKit

@objc public protocol AuroraCarouselDelegate: AnyObject {
    func carouselDidScroll()
}

/// <#Description#>
///
/// <#SuperDuperDescription#>
///
/// **Example**
///
///     let carousel = AuroraCarousel().configure {
///         // Create as many slides as you'd like to show in the carousel
///         $0.slides = [
///           .init(
///             image: UIImage(),
///             title: "Slide 1",
///             description: "The 1th slide"
///           ),
///           .init(
///             image: UIImage(),
///             title: "Slide 2",
///             description: "The 2th slide"
///           ),
///           .init(
///             image: UIImage(),
///             title: "Slide 3",
///             description: "The 3th slide"
///           )
///         ]
///       }
///
///       // Finally where needed:
///       view.addSubView(carousel)
///
public final class AuroraCarousel: UIView,
                                   UICollectionViewDelegateFlowLayout,
                                   UICollectionViewDelegate,
                                   UICollectionViewDataSource {

    // MARK: - Properties
    private var timer: Timer = Timer()
    public var interval: Double = 1.0
    public weak var delegate: AuroraCarouselDelegate?

    public var slides: [AuroraCarouselSlide] = [] {
        didSet {
            updateUI()
        }
    }

    /// Calculates the index of the currently visible ZKCarouselCell
    public var currentlyVisibleIndex: Int? {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return collectionView.indexPathForItem(at: visiblePoint)?.item
    }

    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(tap:)))
        return tap
    }()

    public lazy var pageControl = UIPageControl().configure {
        $0.currentPage = 0
        $0.hidesForSinglePage = true
        $0.pageIndicatorTintColor = .lightGray
        $0.currentPageIndicatorTintColor = UIColor(
            red: 0.20,
            green: 0.60,
            blue: 0.86,
            alpha: 1.0
        )
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    let layout = UICollectionViewFlowLayout().configure {
        $0.scrollDirection = .horizontal
    }

    public lazy var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    ).configure {
        $0.delegate = self
        $0.dataSource = self
        $0.isPagingEnabled = true
        $0.register(
            AuroraCarouselCell.self,
            forCellWithReuseIdentifier: "AuroraCarouselCell"
        )
        $0.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Default Methods

    /// Initialize
    /// - Parameter withSlides: Slides
    init(withSlides: [AuroraCarouselSlide]) {
        super.init(frame: .init())
        self.slides = withSlides
        setupCarousel()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        setupCarousel()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCarousel()
    }

    override public func layoutSubviews() {
        if frame == .init(x: 0, y: 0, width: 0, height: 0) {
            self.frame = (self.superview?.bounds)!
        }
    }

    // MARK: - Internal Methods
    private func setupCarousel() {
        backgroundColor = .clear

        addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.addGestureRecognizer(tapGesture)
        addSubview(pageControl)

        pageControl.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        pageControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 25).isActive = true
        bringSubviewToFront(pageControl)
    }

    @objc private func tapGestureHandler(tap: UITapGestureRecognizer?) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(
            at: visiblePoint
        ) ?? IndexPath(item: 0, section: 0)
        let index = visibleIndexPath.item

        let indexPathToShow = IndexPath(item: index == slides.count - 1 ? 0 : index + 1, section: 0)
        collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
    }

    private func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.pageControl.numberOfPages = self.slides.count
            self.pageControl.size(forNumberOfPages: self.slides.count)
        }
    }

    // MARK: - Exposed Methods
    public func start() {
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(tapGestureHandler(tap:)),
                                     userInfo: nil,
                                     repeats: true)
        timer.fire()
    }

    public func stop() {
        timer.invalidate()
    }

    public func disableTap() {
        /* This method is provided in case you want to remove the
         * default gesture and provide your own. The default gesture
         * changes the slides on tap.
         */
        collectionView.removeGestureRecognizer(tapGesture)
    }

    // MARK: - UICollectionViewDelegate & DataSource
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AuroraCarouselCell.identifier,
            for: indexPath
        ) as? AuroraCarouselCell else {
            fatalError("Can not load AuroraCarouselCell")
        }
        cell.slide = slides[indexPath.item]
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    // MARK: - UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let index = currentlyVisibleIndex {
            pageControl.currentPage = index
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.carouselDidScroll()
    }
}

public class AuroraCarouselCell: UICollectionViewCell {
    static let identifier = "AuroraCarouselCell"

    // MARK: - Properties
    public var slide: AuroraCarouselSlide? {
        didSet {
            guard let slide = slide else {
                print("AuroraCarousel could not parse the slide you provided.")
                return
            }
            parseData(forSlide: slide)
        }
    }

    private lazy var imageView: UIImageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.clipsToBounds = true

//        let gradient = CAGradientLayer().configure {
//            $0.frame = frame
//
//            $0.colors = [
//                UIColor.clear.cgColor,
//                UIColor.black.withAlphaComponent(0.8).cgColor
//            ]
//
//            $0.locations = [
//                0.0,
//                0.6
//            ]
//        }
//
//        $0.layer.insertSublayer(gradient, at: 0)

        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private var titleLabel: UILabel = UILabel().configure {
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.boldSystemFont(ofSize: 40)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private var descriptionLabel: UILabel = UILabel().configure {
        $0.font = UIFont.systemFont(ofSize: 19)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Default Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    private func setup() {
        backgroundColor = .clear
        clipsToBounds = true

        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        contentView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(
            equalTo: contentView.centerYAnchor,
            constant: 32
        ).isActive = true

        descriptionLabel.leftAnchor.constraint(
            equalTo: contentView.leftAnchor,
            constant: 16
        ).isActive = true

        descriptionLabel.rightAnchor.constraint(
            equalTo: contentView.rightAnchor,
            constant: -16
        ).isActive = true

        descriptionLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -16
        ).isActive = true

        contentView.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    private func parseData(forSlide slide: AuroraCarouselSlide) {
        imageView.image = slide.image
        titleLabel.text = slide.title
        descriptionLabel.text = slide.description
    }
}

/// Aurora Carousel Slide
public struct AuroraCarouselSlide {
    /// Slide Image
    public var image: UIImage?
    /// Slide Title
    public var title: String?
    /// Slide Description
    public var description: String?

    /// Aurora Carousel Slide
    /// - Parameters:
    ///   - image: Slide Image
    ///   - title: Slide Title
    ///   - description: Slide Description
    public init(image: UIImage?, title: String?, description: String?) {
        self.image = image
        self.title = title
        self.description = description
    }
}
#endif
