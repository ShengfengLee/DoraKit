//
//  LSFLibraryViewController.swift
//  yoyo
//
//  Created by 李胜锋 on 2019/4/9.
//  Copyright © 2019 Yalla. All rights reserved.
//

import UIKit
import Photos

class LSFLibraryViewController: UIViewController, BarButtonItemable {

    var collectionView: UICollectionView!
    var itemSize: CGSize!

    weak var manager: LSFLibraryManager!
    
    var completeHandle: (([ImagePickerSelection]) -> Void)?
    var backHandle: VoidBlock?
    var cameraHandle: VoidBlock?
    var selectHandle: ((_ index: Int) -> Void)?
    
    init(_ manager: LSFLibraryManager) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        setLeftItem { [weak self] in
            self?.backHandle?()
        }
    
        self.navigationItem.title = LSFLocalized.string("discovier.title.AllPhotos")
        setRightItem(imageNamed: "btn_ok_purple") { [weak self] in
            guard let `self` = self else { return }
            self.completeHandle?(self.manager.selection)
        }

        
        setupCollectionView()
        
        ImagePicker.checkPermission { [weak self] (status) in
            if status {
                self?.manager.fetchRequest()
                self?.collectionView.reloadData()
            }
        }
        
        view.backgroundColor = .white
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        checkSelect()
    }
    
    func setupCollectionView() {
        let width = (self.view.frame.size.width - 30 - 16) / 3
        itemSize = CGSize(width: width, height: width)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.sectionInset = UIEdgeInsets(top: 13, left: 15, bottom: 10, right: 15)
        layout.minimumInteritemSpacing = 5
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LSFLibraryViewCell.self, forCellWithReuseIdentifier: "LSFLibraryViewCell")
        collectionView.register(LSFCameraCell.self, forCellWithReuseIdentifier: "LSFCameraCell")
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }

    
    
    func select(_ assetIdentifier: String?, indexPath: IndexPath) {
        guard let id = assetIdentifier else { return }
        manager.select(id) { [weak self] (isDelete) in
            if isDelete {
                guard let `self` = self else { return }
                var selectIndexPaths = [IndexPath]()
                self.manager.fetchResult?.enumerateObjects { [weak self] (asset, index, _) in
                    if self?.manager.isInSelectionPool(asset.localIdentifier) == true {
                        selectIndexPaths.append(IndexPath(item: index + 1, section: 0))
                    }
                }
                self.collectionView.reloadItems(at: selectIndexPaths)
            }
        }
        collectionView.reloadItems(at: [indexPath])
        checkSelect()
    }
    
    
    func checkSelect() {
        let item = navigationItem.rightBarButtonItem
        if manager.selection.count > 0 {
            item?.isEnabled = true
            item?.image = UIImage(named: "ImagePicker_ok")
        }
        else {
            item?.isEnabled = false
            item?.image = UIImage(named: "ImagePicker_diasable")
        }
    }
}

extension LSFLibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (manager.fetchResult?.count ?? 0) + 1
    }
    
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        ///相机
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LSFCameraCell",
                                                          for: indexPath) as! LSFCameraCell
            return cell
        }
        
        
        let asset = manager.fetchResult![indexPath.item - 1]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LSFLibraryViewCell",
                                                      for: indexPath) as! LSFLibraryViewCell
        cell.assetIdentifier = asset.localIdentifier
        manager.imageManager?.requestImage(for: asset, targetSize: itemSize, contentMode: .aspectFill, options: nil) { image, _ in
            if cell.assetIdentifier == asset.localIdentifier && image != nil {
                cell.imageView.image = image
            }
        }
        

        // Set correct selection number
        if let index = manager.selection.firstIndex(where: { $0.assetIdentifier == asset.localIdentifier }) {
            cell.selectIndicator.set(number: index + 1) // start at 1, not 0
        } else {
            cell.selectIndicator.set(number: nil)
        }
        
        weak var weakCell = cell
        cell.selectIndicator.selectHandle = { [weak self] in
            self?.select(weakCell?.assetIdentifier, indexPath: indexPath)
        }
        
//        UIView.performWithoutAnimation {
//            cell.layoutIfNeeded()
//        }
        
        return cell
    }
    
    
   
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            //照相机
            cameraHandle?()
        }
        else {
            selectHandle?(indexPath.item - 1)
        }
    }
    
   
}

