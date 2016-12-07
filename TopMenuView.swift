//
//  TopMenuView.swift
//  ScrollMenu
//
//  Created by lyf on 15/7/9.
//  Copyright © 2015年 zn. All rights reserved.
//  顶部可以滚动横条

import UIKit
private let reuseIdentifier = "TopCollectionViewCell"


let topViewHeight: CGFloat = 40.0



protocol TopMenuDelegate {
    func topMenuDidChangedToIndex(_ index:Int)
}

class TopMenuView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    fileprivate var collection: UICollectionView?
    fileprivate var flowLayout: UICollectionViewFlowLayout?
    fileprivate var lineView: UIView?
    
    //为了去除第一次时移动的埋点
    var isFirstSelect = true
    
    /// 当前选中row
    var selectRow : Int = 0
    
    /// 下拉更多按钮是否选中
    var isSelectClick : Bool = false
    
    var allTagView : UIView!
    
    /// 数量
    var cellNum: CGFloat = 4
    
    /// cell的宽度
    var btnForW = FULL_WIDTH / 4
    
    /// 是否根据文本长度显示cell的宽度
    var isTextW = false
    
    //整行menu背景颜色
    var bgColor: UIColor?
    
    /// 底部线宽度
    var lineforCellW: CGFloat = 21
    
    ///底部线的x位置
    var lineforCellX: CGFloat = 35
    
    /* 下方跟随滚动的线条的颜色 */
    var lineColor: UIColor?
    
    /// 字体大小
    var fontSize:CGFloat = 14
    
    /* 所有的标题 */
    var titles = [NSString](){

        didSet(value){
            self.configTagListView()
        }
    }
    
    /*标记是否显示了scrollview*/
    var isShowScrollView = false
    
    /* 标签页view的宽度 */
    var allTagW : CGFloat = 0
    
    /* 标签页的滚动页scrollView*/
    var scrollView = UIScrollView()
    
    /*下啦按钮 tagViewBtn*/
    var tagViewBtn = UIButton()
    
    /// 是否显示底部的线
    var showBottomLine = true
    
    weak var delegate: TopMenuDelegate?
    
    let selectRed: CGFloat = 252
    
    let selectGreen: CGFloat = 130
    
    let selectBlue: CGFloat = 0
    

    init() {
         super.init(frame: CGRect(x: 0.0, y: kStatusHeight, width: kScreenSize.width, height: topViewHeight))
        self.setupCollectionView()
       
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCollectionView()
        
    }
    
    init(frame: CGRect, cellNum: CGFloat) {
        super.init(frame: frame)
        self.cellNum = cellNum
        self.btnForW = FULL_WIDTH / cellNum
        self.lineforCellX = (FULL_WIDTH / cellNum - lineforCellW) / 2
        self.setupCollectionView()
        
    }
    
    init(frame: CGRect, cellNum: CGFloat, cellW: CGFloat, lineforCellW: CGFloat, showBottomLine: Bool, fontSize: CGFloat){
        super.init(frame: frame)
        self.cellNum = cellNum
        self.btnForW = cellW
        self.lineforCellW = lineforCellW
        self.showBottomLine = showBottomLine
        self.fontSize = fontSize
        self.setupCollectionView() 

    }
    
    
    func titles( _ titles : [NSString]){
        self.titles = titles
    }

    //MARK: - 设置item 用collectionView的方式
    func setupCollectionView(){
       
        self.backgroundColor = UIColor.white

        
        //设置scrolltagview
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: allTagW, width: FULL_WIDTH, height: FULL_HEIGHT))
        scrollView.contentSize = CGSize(width: FULL_WIDTH, height: FULL_HEIGHT )
        scrollView.backgroundColor = UIColor.white
        if isShowScrollView == false{
            scrollView.frame.origin.y = -FULL_HEIGHT
        }else{
            scrollView.frame.origin.y = 40
        }
        self.addSubview(scrollView)
        
        scrollView.isUserInteractionEnabled = true
        let tapTagViewBlack = UITapGestureRecognizer(target: self, action: #selector(TopMenuView.tapTagViewBlack(_:)))
        scrollView.addGestureRecognizer(tapTagViewBlack)
        

        self.scrollView = scrollView
        
        
        //设置collectionView的布局
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        self.flowLayout = flowLayout
        
      
        
        //设置 collectionView
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: FULL_WIDTH - self.allTagW, height: topViewHeight), collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.bounces = false
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        
        self.addSubview(collection)
        self.collection = collection
        
        //设置底部灰线
        if self.showBottomLine {
            let blLine = UIView(frame: CGRect(x: 0,y: self.frame.size.height - 0.5,width: FULL_WIDTH,height: 0.5))
            
            blLine.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 0.5)
            self.addSubview(blLine)
        }
        
        //设置底部跟随滚动的线
        let bottomView = UIView(frame: CGRect(x: lineforCellX, y: topViewHeight - 2, width: lineforCellW, height: 2))
        bottomView.backgroundColor = UIColor(red: 254 / 255, green: 191 / 255, blue: 41 / 255, alpha: 1)
        self.collection!.addSubview(bottomView)
        self.lineView = bottomView

        
        //注册cell
        self.collection?.register(TopCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
    }
    
    override func layoutSubviews() {
       
    }
    
    func configTagListView(){
        
        if self.titles.count == 0 {
            return
        }
        
        
        for one in self.scrollView.subviews{
            one.removeFromSuperview()
        }
        
        
        
        let topX : CGFloat = 10
        
        let topY : CGFloat = 10
        
        var btnW : CGFloat = 100
        
        let btnH : CGFloat = 35
        
        var btnY : CGFloat = 10
        
        var btnX : CGFloat = 10
        
        for one in self.titles{
            
            let attributes = NSDictionary(object: UIFont.systemFont(ofSize: 14), forKey: NSFontAttributeName as NSCopying)
            
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let text : NSString = one
            let constrainedToSize = CGSize( width: CGFloat(MAXFLOAT) , height: CGFloat(MAXFLOAT))
            
            let textSize = text.boundingRect(with: constrainedToSize, options: option, attributes: attributes as? [String : AnyObject], context: nil).size
            print(textSize.width)
            btnW = textSize.width + 20
            
            if btnX + topX + btnW > FULL_WIDTH{
                btnY = btnY + topY + btnH
                btnX = 10
            }
            
            let tagBtn = UIButton(frame: CGRect(x: btnX, y: btnY, width: btnW, height: btnH))
            tagBtn.setTitle(one as String, for: UIControlState())
            tagBtn.setTitleColor(UIColor(red: 102 / 255, green: 102 / 255, blue: 102 / 255, alpha: 1), for: UIControlState())
            tagBtn.layer.cornerRadius = 6
            tagBtn.layer.borderWidth = 0.5
            tagBtn.titleLabel?.font = YD_Font(14)
            tagBtn.layer.borderColor = UIColor(red: 215 / 255, green: 215 / 255, blue: 215 / 255, alpha: 1).cgColor
            tagBtn.addTarget(self, action: #selector(TopMenuView.tagBtnClick(_:)), for: .touchUpInside)
            scrollView.addSubview(tagBtn)
            
            btnX = btnX + topX + btnW
            
        }
        
        
        
        scrollView.contentSize = CGSize(width: FULL_WIDTH, height: btnY + btnH )
        
    }
    
    func reloadCellView(){
        self.collection?.reloadData()
    }
    
    //MARK: - collectionViewDataSource method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        print(self.titles.count)
        
        return self.titles.count;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TopCollectionViewCell
        cell.fontSize = fontSize
        cell.setupLable()
        cell.titleName = self.titles[(indexPath as NSIndexPath).item]
        cell.backgroundColor = UIColor.clear
        cell.titleColor = UIColor.black
        if (indexPath as NSIndexPath).item == self.titles.count-1 {
          let width = cell.frame.maxX
            if width < kScreenSize.width {
                self.setCollectionFrame(cell.frame)
            }
            
        }
        
        if (indexPath as NSIndexPath).row == self.selectRow {
            if let label = cell.titleLabel{
                label.textColor = UIColor(red:   (selectRed / 255), green:  (selectGreen / 255), blue:  (selectBlue / 255), alpha: 1)
                
                
                label.transform = CGAffineTransform(scaleX: 1, y: 1)
               
            }
        }else{
            if let label = cell.titleLabel{
                label.textColor = UIColor(red: 70 / 255, green: 70 / 255, blue: 70 / 255, alpha: 1)
                label.transform = CGAffineTransform(scaleX: 1, y: 1)
            }

        }
        
        return cell
    }
    //MARK: - 设置collection的frame
    func setCollectionFrame(_ lastItemFrame : CGRect){
        let cWidth:CGFloat = lastItemFrame.maxX
        let cHeight:CGFloat = topViewHeight
        let cY:CGFloat = self.bounds.origin.y
        self.collection?.frame = CGRect(x: 0, y: cY, width: cWidth, height: cHeight)
    
    }
    //MARK: - UICollectionViewDelegate method
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectRow = (indexPath as NSIndexPath).row
        
        self.isSelectClick = true
        
        //当点击了menu 通知代理
        self.delegate?.topMenuDidChangedToIndex((indexPath as NSIndexPath).item)
      
        
     
    }
    //移动topMenu 及滚动的线
    func moveTopMenu( _ indexPath: IndexPath){
        if self.viewController is BrowsMainNewViewController {
            
            if isFirstSelect {
                isFirstSelect = false
            }else {
               
            }
        }
        
        
        var nextIndexPath = IndexPath(item: (indexPath as NSIndexPath).item+2, section: 0)
        if (nextIndexPath as NSIndexPath).item > self.titles.count-1 {
            nextIndexPath = IndexPath(item: self.titles.count-1, section: 0)
        }
        var lastIndexPath = IndexPath(item: (indexPath as NSIndexPath).item-2, section: 0)
        if (lastIndexPath as NSIndexPath).item < 0 {
            lastIndexPath = IndexPath(item: 0, section: 0)
        }
        let visibleItems = self.collection?.indexPathsForVisibleItems
        if let visibleItem = visibleItems {
            if !visibleItem.contains(nextIndexPath) || (nextIndexPath as NSIndexPath).item == self.titles.count-1 {
                self.collection?.scrollToItem(at: nextIndexPath, at: UICollectionViewScrollPosition.right, animated: true)
                
            }
            if !visibleItem.contains(lastIndexPath) || (lastIndexPath as NSIndexPath).item == 0 {
                self.collection?.scrollToItem(at: lastIndexPath, at: UICollectionViewScrollPosition.left, animated: true)
                
            }
            
        }
        
    
        if let cell = self.collection!.cellForItem(at: indexPath) as? TopCollectionViewCell{
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                
                if self.isTextW {
                    
                    self.lineView!.frame = CGRect(x: cell.frame.origin.x + self.lineforCellX, y: cell.frame.size.height-2, width: self.titles[(indexPath as NSIndexPath).row].sizeByFont(UIFont.systemFont(ofSize: self.fontSize)).width , height: 2);
                }else{
                
                    self.lineView!.frame = CGRect(x: cell.frame.origin.x + self.lineforCellX, y: cell.frame.size.height-2, width: self.lineforCellW , height: 2);
                }
            }) 
        }else{
           let cell = self.collectionView(self.collection!, cellForItemAt: indexPath)
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                if self.isTextW {
                    
                    self.lineView!.frame = CGRect(x: cell.frame.origin.x + self.lineforCellX, y: cell.frame.size.height-2, width: self.titles[(indexPath as NSIndexPath).row].sizeByFont(UIFont.systemFont(ofSize: self.fontSize)).width , height: 2);
                }else{
                    
                    self.lineView!.frame = CGRect(x: cell.frame.origin.x + self.lineforCellX, y: cell.frame.size.height-2, width: self.lineforCellW , height: 2);
                }

            }) 
        }
        
    
        
        
    }
    
    
    func setLabelView(_ scrollView : UIScrollView){
        
        
        for  i in 0...self.collection!.numberOfItems(inSection: 0){
            
            let indexPath = IndexPath(item: i, section: 0)
           
            if let cell = self.collection?.cellForItem(at: indexPath) as? TopCollectionViewCell{
                if let label = cell.titleLabel{
                    label.textColor = UIColor(red: 70 / 255, green: 70 / 255, blue: 70 / 255, alpha: 1)
                }
            }

            
            
        }
        
        let value = abs(scrollView.contentOffset.x / FULL_WIDTH)
        let leftIndex = Int(value)
        let rightIndex = leftIndex + 1
        let scaleRight = value - CGFloat(leftIndex)
        let scaleLeft = 1 - scaleRight
       
        self.selectRow = leftIndex
        
        
        if let cell = self.collection?.cellForItem(at: IndexPath(row: leftIndex, section: 0)) as? TopCollectionViewCell{
            let leftLine1X = cell.frame.origin.x
            let leftLineW = cell.frame.size.width
            var wSub : CGFloat =  self.titles[leftIndex].sizeByFont(UIFont.systemFont(ofSize: self.fontSize)).width
            
            if let _ = self.collection?.cellForItem(at: IndexPath(row: rightIndex, section: 0)) as? TopCollectionViewCell{
                let w = self.titles[leftIndex].sizeByFont(UIFont.systemFont(ofSize: self.fontSize)).width - self.titles[rightIndex].sizeByFont(UIFont.systemFont(ofSize: self.fontSize)).width
                wSub = self.titles[leftIndex].sizeByFont(UIFont.systemFont(ofSize: self.fontSize)).width - w * (1 - scaleLeft)
                
            }
            

            if let label = cell.titleLabel{
                
                let lineScale = leftLine1X + (leftLineW )*(1-scaleLeft)
               
                
                
                let blackColo = UIColor(red: (70 + (selectRed - 70) * scaleLeft) / 255, green: (70 + (selectGreen - 70) * scaleLeft) / 255, blue: (70 + (selectBlue - 70) * scaleLeft) / 255, alpha: 1)
                
                if self.isSelectClick {
                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                        label.textColor = blackColo
                        
                        if self.isTextW {
                            
                            self.lineView!.frame = CGRect(x: lineScale + self.lineforCellX, y: cell.frame.size.height-2, width: self.titles[leftIndex].sizeByFont(UIFont.systemFont(ofSize: self.fontSize)).width , height: 2);
                        }else{
                            
                           self.lineView!.frame = CGRect(x: lineScale + self.lineforCellX, y: cell.frame.size.height-2,  width: self.lineforCellW  , height: 2)
                        }

                        
                    }) 
                    
               
                }else{
                    
                    if self.isTextW {
                        
                        self.lineView!.frame = CGRect(x: lineScale + self.lineforCellX, y: cell.frame.size.height-2, width: wSub, height: 2);
                    }else{
                        
                        self.lineView!.frame = CGRect(x: lineScale + self.lineforCellX, y: cell.frame.size.height-2,  width: self.lineforCellW  , height: 2)
                    }

                    
                    label.textColor = blackColo                    

                }
            }

        }else if(self.isSelectClick == true){
            self.moveTopMenu(IndexPath(item: leftIndex, section: 0))

        }
        

        if let cell2 = self.collection?.cellForItem(at: IndexPath(row: rightIndex, section: 0)) as? TopCollectionViewCell{
            if let label = cell2.titleLabel{
                
                let blackColo = UIColor(red: (70 + (selectRed - 70) * scaleRight) / 255, green: (70 + (selectGreen - 70) * scaleRight) / 255, blue: (70 + (selectBlue - 70) * scaleRight) / 255, alpha: 1)
                
                
                if self.isSelectClick {
                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                      
                     label.textColor = blackColo
                    }) 
                }else{
                    label.textColor = blackColo

                }
            }
            
        }
        self.isSelectClick = false
        
    }
    
    //MARK: tagViewBtnClick头部下拉标签点击
    func tagViewBtnClick(_ sender: UIButton){
        
        if sender.isSelected == false{
            sender.isSelected = true
           
            if #available(iOS 8.0, *) {
                self.backgroundColor = UIColor.white
                self.collection?.backgroundColor = UIColor.white
                self.allTagView.backgroundColor = UIColor.white
            }
            
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                
                self.frame.size.height = FULL_HEIGHT - 90
                self.scrollView.frame.origin.y = 40
                
            }) 
           
        }else{
            sender.isSelected = false
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.scrollView.frame.origin.y = -FULL_HEIGHT
                self.frame.size.height = 40
                }, completion: { (finsh) -> Void in
                    if #available(iOS 8.0, *) {
                        self.backgroundColor = UIColor.clear
                        self.collection?.backgroundColor = UIColor.clear
                        self.allTagView.backgroundColor = UIColor.clear
                    }
            })
            
        }
        
        
    }
    
    //MARK: tagBtnClick
    func tagBtnClick(_ sender : UIButton){
        
        self.tagViewBtnClick(self.tagViewBtn)
        
        if let text = sender.titleLabel?.text{
            var i = 0
            for one in self.titles{
                if one as String == text {
                    if let collection = self.collection{
                        self.collectionView(collection, didSelectItemAt: IndexPath(row: i, section: 0))
                        break
                    }
                }
                i += 1
            }
            
        }
    }
    
    //MARK: 点击背景 上拉
    func tapTagViewBlack(_ sender: UITapGestureRecognizer ) {
    
        self.tagBtnClick(self.tagViewBtn)
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout method
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if self.isTextW {
            let titleSize = self.titles[(indexPath as NSIndexPath).item].sizeByFont(UIFont.systemFont(ofSize: self.fontSize))
            self.lineforCellX = 15
            return CGSize(width: titleSize.width+30, height: topViewHeight)
        }
        return CGSize(width: self.btnForW, height: topViewHeight)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
