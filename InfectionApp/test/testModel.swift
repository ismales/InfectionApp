import UIKit

protocol GroupObjectDelegate: AnyObject {
    func didTap(groupObject: GroupObject)
}

class GroupObject: UIView {
    weak var delegate: GroupObjectDelegate?

    var isInfected = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setInfected() {
        isInfected = true
        backgroundColor = .red
    }

    func setHealthy() {
        isInfected = false
        backgroundColor = .green
    }

    @objc private func didTap() {
        delegate?.didTap(groupObject: self)
    }
}
