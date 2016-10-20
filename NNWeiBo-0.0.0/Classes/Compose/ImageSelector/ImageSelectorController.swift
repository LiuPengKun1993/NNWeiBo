//
//  ImageSelectorController.swift
//  ImageSelector
//
//  Created by iOS on 16/10/18.
//  Copyright © 2016年 YMWM. All rights reserved.
//

import UIKit

private let NNImageSelectorCellReuseIdentifier = "NNImageSelectorCellReuseIdentifier"
class ImageSelectorController: UIViewController {

    override func viewDidLoad() {
         super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        //  添加子控件
        view.addSubview(collectionView)
        
        // 布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        view.addConstraints(cons)
        
    }
    
    // MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout:ImageSelectorViewLayout())
        clv.registerClass(ImageSelectorCell.self, forCellWithReuseIdentifier: NNImageSelectorCellReuseIdentifier)
        clv.dataSource = self
        return clv
    }()
    
    lazy var pictureImages = [UIImage]()
}

extension ImageSelectorController: UICollectionViewDataSource,ImageSelectorCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureImages.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NNImageSelectorCellReuseIdentifier, forIndexPath: indexPath) as! ImageSelectorCell
        
        cell.ImageCellDelegate = self
        
        cell.backgroundColor = UIColor.greenColor()

        cell.image = (pictureImages.count == indexPath.item) ? nil : pictureImages[indexPath.item] // 0  1
        
        return cell
    }
    
    func imageDidAddSelctor(cell: ImageSelectorCell) {
    
        // 判断能否打开照片库
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            print("不能打开相册")
            return
        }
        
        // 2.创建图片选择器
        let vc = UIImagePickerController()
        
        vc.delegate = self
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    /**
     选中相片之后调用
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    
        let newImage = image.imageWithScale(300)
        pictureImages.append(newImage)
        collectionView.reloadData()
        
        // 注意: 如果实现了该方法, 需要我们自己关闭图片选择器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageDidRemoveSelector(cell: ImageSelectorCell) {
        
        // 从数组中移除"当前点击"的图片
        let indexPath = collectionView.indexPathForCell(cell)
        pictureImages.removeAtIndex(indexPath!.item)
        // 刷新表格
        collectionView.reloadData()
    }
}

@objc
protocol ImageSelectorCellDelegate : NSObjectProtocol {
    optional func imageDidAddSelctor(cell: ImageSelectorCell)
    optional func imageDidRemoveSelector(cell: ImageSelectorCell)
}

class ImageSelectorCell: UICollectionViewCell {
    weak var ImageCellDelegate: ImageSelectorCellDelegate?
    
    var image: UIImage? {
        didSet {
            if image != nil {
                removeButton.hidden = false
                addButton.setBackgroundImage(image!, forState: UIControlState.Normal)
                addButton.userInteractionEnabled = false
            } else {
                removeButton.hidden = true
                addButton.userInteractionEnabled = true
                addButton.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
                addButton.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    
    private func setupUI() {
        // 添加子控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        // 布局子控件
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addButton": addButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[removeButton]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton": removeButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(-1)-[removeButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton": removeButton])
        
        contentView.addConstraints(cons)
    }
    
    // MARK: - 懒加载
    private lazy var removeButton: UIButton = {
        let btn = UIButton()
        btn.hidden = true
        btn.setBackgroundImage(UIImage(named: "compose_photo_close@2x"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(ImageSelectorCell.removeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        btn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
        
        btn.addTarget(self, action: #selector(ImageSelectorCell.addBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    func removeBtnClick() {
        ImageCellDelegate?.imageDidRemoveSelector!(self)
    }
    
    func addBtnClick() {
        ImageCellDelegate?.imageDidAddSelctor!(self)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageSelectorViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {

        let w = UIScreen.mainScreen().bounds.width / 4 - 10
        itemSize = CGSize(width: w, height: w)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
}

