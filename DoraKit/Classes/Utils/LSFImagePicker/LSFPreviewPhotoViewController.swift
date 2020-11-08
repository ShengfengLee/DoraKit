//
//  LSFPreviewPhotoViewController.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/4/10.
//  Copyright © 2019 Yalla. All rights reserved.
//

import UIKit

class LSFPreviewPhotoViewController: LSFLibraryViewController {
    
    let selectIndicator = LSFSelectionIndicatorView(size: 18)
    
    var index: Int = 0 {
        didSet {
            if oldValue == index {
                return
            }
            updateIndex()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        
        view.backgroundColor = UIColor.lsf_color16(0xF5F5F5)
        
        setupBottom()
        
        
        if index > 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
                let point = CGPoint(x: self.itemSize.width * CGFloat(self.index), y: 0)
                let rect = CGRect(origin: point, size: self.itemSize)
                self.collectionView.scrollRectToVisible(rect, animated: false)
                self.updateIndex()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setupCollectionView() {
        itemSize = self.view.frame.size
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(LSFPreviewPhotoCell.self, forCellWithReuseIdentifier: "LSFPreviewPhotoCell")
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    
    func setupBottom() {
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (maker) in
            maker.bottom.leading.trailing.equalTo(0)
            maker.height.equalTo(UIView.lsf_safeAreaInsets().bottom + 49)
        }
        
        let selectLabel = UILabel()
        selectLabel.text = LSFLocalized.string("title.matching.select")
        selectLabel.textColor = UIColor.lsf_color16(0x4A4A4A)
        selectLabel.font = UIFont.systemFont(ofSize: 15)
        bottomView.addSubview(selectLabel)
        selectLabel.snp.makeConstraints { (maker) in
            maker.trailing.equalTo(-15)
        }
        
        selectIndicator.selectHandle = { [weak self] in
            self?.select()
        }
        bottomView.addSubview(selectIndicator)
        selectIndicator.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 18, height: 18))
            maker.centerY.equalTo(selectLabel.snp.centerY)
            maker.top.equalTo(15)
            maker.trailing.equalTo(selectLabel.snp.leading).offset(-5)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.fetchResult?.count ?? 0
    }
    
    
    override public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        let asset = manager.fetchResult![indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LSFPreviewPhotoCell",
                                                      for: indexPath) as! LSFPreviewPhotoCell
        cell.assetIdentifier = asset.localIdentifier
        manager.imageManager?.requestImage(for: asset, targetSize: itemSize, contentMode: .aspectFill, options: nil) { image, _ in
            if cell.assetIdentifier == asset.localIdentifier && image != nil {
                cell.imageView.image = image
            }
        }
        
        UIView.performWithoutAnimation {
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / itemSize.width
        self.index = Int(page)
    }
    
    func updateIndex() {
        guard let fetchResult = manager.fetchResult else { return }
        let asset = fetchResult[index]
        if let index = manager.selection.firstIndex(where: { $0.assetIdentifier == asset.localIdentifier }) {
            selectIndicator.set(number: index + 1) // start at 1, not 0
        } else {
            selectIndicator.set(number: nil)
        }
    }
    
    func select() {
        guard let fetchResult = manager.fetchResult else { return }
        let asset = fetchResult[index]
        manager.select(asset.localIdentifier, complete: nil)
        updateIndex()
        checkSelect()
    }
    
    
}

