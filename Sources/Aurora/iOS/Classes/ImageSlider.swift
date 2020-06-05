// $$HEADER$$

#if os(iOS)
import Foundation
import UIKit

/// <#Description#>
open class ImageSlider {
    var images: [UIImage] = []
    var imageHeight: Int
    var pageControl: UIPageControl
    var scrollView: UIScrollView
    var colors: [UIColor] = [.red, .orange, .green, .yellow, .gray, .cyan, .clear, .brown, .black]
    
    /// <#Description#>
    /// - Parameters:
    ///   - images: <#images description#>
    ///   - view: <#view description#>
    ///   - pageControl: <#pageControl description#>
    ///   - scrollView: <#scrollView description#>
    ///   - height: <#height description#>
    public init(images: [UIImage], view: UIViewController, pageControl: UIPageControl, scrollView: UIScrollView, height: Int? = Int.max) {
        self.images = images
        self.imageHeight = height!
        self.pageControl = pageControl
        self.scrollView = scrollView
        
        // Screen width.
        let imageSizeAsInt = Int.init(scrollView.frame.size.width)
        let imageSizeAsFloat = scrollView.frame.size.width
        
        // Content size
        scrollView.contentSize = CGSize.init(width: CGFloat(imageSizeAsInt * images.count), height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
//        scrollView.clipsToBounds = false
        scrollView.delegate = view as? UIScrollViewDelegate
        pageControl.numberOfPages = 0
        var xPos: CGFloat = 0.0
        
        for image in images {
            let imageView = UIImageView.init(frame: CGRect(x: xPos, y: 0.0, width: imageSizeAsFloat, height: scrollView.frame.size.height))
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            imageView.image = image.imageResize(sizeChange: CGSize(width: imageSizeAsFloat, height: scrollView.frame.size.height))
            scrollView.addSubview(imageView)
            
            xPos += imageSizeAsFloat
            pageControl.numberOfPages += 1
        }
        
        // Fix scroll to bottom
        scrollView.contentSize = CGSize.init(width: scrollView.contentSize.width, height: 0)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - scrollView: <#scrollView description#>
    ///   - view: <#view description#>
    ///   - pageControl: <#pageControl description#>
    public func scroll(scrollView: UIScrollView, view: UIViewController, pageControl: UIPageControl) {
        let currentPage: Int = Int.init(floor(scrollView.contentOffset.x / view.view.frame.size.width))
//        print("CurrentPage=\(currentPage) x:\(scrollView.contentOffset.x)")
        pageControl.currentPage = currentPage
    }
}
#endif
