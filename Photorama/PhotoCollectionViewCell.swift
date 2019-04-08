import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    //This will be called before the cell is used. Initial load
    override func awakeFromNib() {
        super.awakeFromNib()
        update(with: nil)
    }
    
    //This will be called when the cell is about to get reused
    override func prepareForReuse() {
        super.prepareForReuse()
        update(with: nil)
    }
    

    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}
