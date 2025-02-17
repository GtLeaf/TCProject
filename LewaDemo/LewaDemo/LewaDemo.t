﻿
var centerX=640, centerY=550
//插件注册
var lw, dm
function dllRegister()
    //乐玩
    var lw_reg = regdll("rc:lw.dll", true)
    if(!lw_reg)
        return
    end
    lw = com("lw.lwsoft3")
    
    //大漠
    var dm_reg = regdll("rc:dm.dll", true)
    if(!dm_reg)
        return
    end
    dm = com("dm.dmsoft")
end

//绑定窗口
var hwnd
function bindWindow()
    hwnd = lw.FindWindow("DMO", "DMO")
    lw.MoveWindow(hwnd, 0, 0)
    var lw_hwnd = lw.BindWindow(hwnd, 1, 0, 0, 0)
    var dm_hwnd = dm.BindWindow(hwnd, "normal", "normal", "normal", 0)
end

功能 LewaDemo_初始化()
    //这里添加你要执行的代码
    //初始化插件
    dllRegister()
    bindWindow()
结束

//识别锁定对象
function myFindPic(pic)
    //未指定对象,执行无差别攻击
    if("1" == pic)
        return 1
    end
    var x=-1, y=-1, n=0
    while(n<10)
        dm.FindPic(0,0,850,300,pic, "000000", 0.6, 2, x, y)
        if(x>0 && y>0)
            return 1
        end
        n = n+1
    end
    
    return 0
end

//鼠标移动人物:1上 2下 3左 4右
function characterMove(direct)
    if(1 == direct)//上
        lw.MoveTo(660, 320)
        lw.LeftClick()
        lw.delay(100)
        lw.LeftClick()
    elseif(2 == direct)//下
        lw.MoveTo(660, 720)
        lw.LeftClick()
        lw.delay(100)
        lw.LeftClick()
    elseif(3 == direct)//左
        lw.MoveTo(350, 530)
        lw.LeftClick()
        lw.delay(100)
        lw.LeftClick()
    elseif(4 == direct)//右
        lw.MoveTo(950, 530)
        lw.LeftClick()
        lw.delay(100)
        lw.LeftClick()
    end
    lw.delay(500)
end

function mouseMoveCharacter(x, y)
    lw.MoveTo(x, y)
    lw.LeftClick()
    lw.delay(100)
    lw.LeftClick()
    lw.delay(100)
    lw.LeftClick()
    lw.delay(100)
    lw.LeftClick()
    lw.delay(100)
    lw.LeftClick()
    lw.delay(100)
end

//算法获取鼠标应该点击的坐标
function calculateXY(xA, yA, xB, yB, r)
    //象限照样按正象限坐标
    var quadrant = 1
    
    
    //左上角第一象限,以B点为坐标中心,注意,屏幕坐标y轴朝下
    if(xA<=xB && yA<yB)
        quadrant = 1
    elseif(xA>xB && yA<=yB)//右上角第二象限
        quadrant = 2
    elseif(xA<=xB && yA>yB)//左下角第三象限
        quadrant = 3
    elseif(xA>xB && yA>=yB)//右下角第四象限
        quadrant = 4
    end
    
    if(0 == (xB-xA))
        var arrPoint
        if(2 == quadrant || 4 == quadrant)
            arrPoint = array("x"=10, "y"=-r)
        end
        if(1 == quadrant || 3 == quadrant)
            arrPoint = array("x"=10, "y"=r)
        end
        列表框增加文本("列表框_状态框", "quadrant="&quadrant)
        return arrPoint
    end
    var k = (yB-yA)/(xB-xA)
    //    列表框增加文本("列表框_状态框", "k="&k&"象限="&quadrant)
    
    var moveX = msqrt((r*r)/(1+k*k))
    var moveY = msqrt((r*r*k*k)/(1+k*k))
    
    if(1 == quadrant)
        moveX = -moveX
        moveY = -moveY
    elseif(2 == quadrant)
        moveY = -moveY
    elseif(3 == quadrant)
        moveX = -moveX
    elseif(4 == quadrant)
        //第四象限x,y都是正数
    end
    var arrPoint = array("x"=moveX, "y"=moveY)
    
    return arrPoint
    
end

//
//添加锚点模块
//
var anchorXMap = array()
var anchorYMap = array()
var anchorNum = 0
var anchorXName = "编辑框_锚点x"
var anchorYName = "编辑框_锚点y"
var anchorComboName = "下拉框_锚点集"
功能 下拉框_锚点集_选择改变()
    var str = 下拉框获取文本(anchorComboName)
    编辑框设置文本(anchorXName, anchorXMap[下拉框获取文本(anchorComboName)])
    编辑框设置文本(anchorYName, anchorYMap[下拉框获取文本(anchorComboName)])
结束

//添加x,y和下拉框新选项,并将下拉框设置为新选项
功能 按钮_添加锚点_点击()
    
    //如果x,y坐标不为空
    if(null != 编辑框获取文本(anchorXName) && null != 编辑框获取文本(anchorYName))
        下拉框增加文本(anchorComboName, "锚点"&anchorNum)
        arraypush(anchorXMap, 编辑框获取文本(anchorXName), "锚点"&anchorNum)
        arraypush(anchorYMap, 编辑框获取文本(anchorYName), "锚点"&anchorNum)
        //将下拉框设置为新选项
        下拉框设置选项(anchorComboName, anchorNum)
        列表框增加文本("列表框_状态框", "锚点"&anchorNum&"("&编辑框获取文本(anchorXName)&","&编辑框获取文本(anchorYName)&")添加成功")
        anchorNum = anchorNum+1
        
    end
    
    
结束


功能 按钮_获取坐标_点击()
    
    myFindSelfXY(anchorXName, anchorYName)
    
结束

//删除对应key的x,y,下拉框的项,锚点数减一,并更新编辑框和下拉框
功能 按钮_删除锚点_点击()
    arraydeletekey(anchorXMap, 下拉框获取文本(anchorComboName))
    arraydeletekey(anchorYMap, 下拉框获取文本(anchorComboName))
    下拉框删除选项文本("下拉框_锚点集", 下拉框获取选项(anchorComboName))
    anchorNum = anchorNum-1
    
    //更新
    编辑框设置文本(anchorXName, "")
    编辑框设置文本(anchorYName, "")
    下拉框设置选项(anchorComboName, 0)
结束

//更新锚点,直接改变x.y值
功能 按钮_更新锚点_点击()
    anchorXMap[下拉框获取文本(anchorComboName)] = 编辑框获取文本(anchorXName)
    anchorYMap[下拉框获取文本(anchorComboName)] = 编辑框获取文本(anchorYName)
结束


//以移动到锚点
var moveThreadID = -1
var nextPoint = 0
function moveToPoint()
    var isBreak = false
    
    //没有锚点不移动
    if(0 == anchorNum)
        return
    end
    
    var x=-1, y=-1
    var oldX=x, oldY=y
    while(flag)
        var point = "锚点"&nextPoint
        var pointX = cdouble(anchorXMap[point])
        var pointY = cdouble(anchorYMap[point])
        
        x=-1
        y=-1
        //打开地图
        lw.KeyPress(77)
        lw.delay(100)
        var picPath = getrcpath("rc:map_自己1.bmp")&"|"&getrcpath("rc:map_自己2.bmp")
        //精确度为0.5最佳
        if(单选框获取状态("单选框_西部巴达"))
            dm.FindPic(466,284,826,728,picPath, "000000", 0.5, 2, x, y)//西部专用
        elseif(单选框获取状态("单选框_银光比特"))
            dm.FindPic(324,168,956,804,picPath , "000000", 0.5, 3, x, y)//银光湖
        else
            dm.FindPic(324,168,956,804,picPath, "000000", 0.5, 2, x, y)
        end
        //关闭地图
        lw.KeyPress(77)
        lw.delay(100)
        
        if(x>=0 && y>=0)
            oldX = x
            oldY = y
        end
        if(x<0 || y<0)
            列表框增加文本("列表框_状态框", "获取坐标错误,使用之前坐标点")
            x = oldX
            y = oldY
            //            return
        end
        
        //用一元线性方程与圆相交求鼠标该指向的点,把k的符号弄丢了
        var arrPoint = calculateXY(pointX, pointY, cdouble(x), cdouble(y), 100.0)
        var moveX = arrPoint["x"]
        var moveY = arrPoint["y"]
        
        mouseMoveCharacter(centerX+moveX, centerY+moveY)
        lw.delay(100)
        //                        列表框增加文本("列表框_状态框", "当前坐标:("&x&","&y&")")
        //                        列表框增加文本("列表框_状态框", "点击:("&moveX&","&moveY&")")
        if(x<pointX+10 && x>pointX-10 && y<pointY+10 && y>pointY-10)
            列表框增加文本("列表框_状态框", "已到达"&point)
            nextPoint = (nextPoint+1)%anchorNum
        end
    end
    //flag=false时,线程停止
    moveThreadID = -1
end

//获取攻击对象
var attackFlag = true
function getAttackTarget()
    var str = "1"
    //读取攻击目标
    var attach_target = combogettext("下拉框_攻击对象")
    var attach_target2 = combogettext("下拉框_攻击对象2")
    if("" != attach_target)
        attach_target = "rc:"&attach_target
        //		str = attach_target&"1.bmp|"&attach_target&"2.bmp|"&attach_target&"3.bmp"
        str = getrcpath(attach_target&"1.bmp")&"|"&getrcpath(attach_target&"2.bmp")&"|"&getrcpath(attach_target&"3.bmp")  
    end
    
    if("" != attach_target2)
        attach_target2 = "rc:"&attach_target2
        //        str = str&"|"&attach_target2&"1.bmp|"&attach_target2&"2.bmp|"&attach_target2&"3.bmp"
        str = str&"|"&getrcpath(attach_target2&"1.bmp")&"|"&getrcpath(attach_target2&"2.bmp")&"|"&getrcpath(attach_target2&"3.bmp")
    end
    //未指定对象,执行无差别攻击
    if("1" == str)
        if(attackFlag)
            列表框增加文本("列表框_状态框", "未指定对象,执行无差别攻击")
        end
        attackFlag = false
    end
    return str
end


//判断地图是否打开
function judgeMapIsOpen()
    var pic = getrcpath("rc:map1.bmp")&"|"&getrcpath("rc:map2.bmp")&"|"&getrcpath("rc:map3.bmp")
    var x=-1, y=-1, n=0
    while(n<2)
        dm.FindPic(324,168,956,264,pic, "000000", 0.8, 2, x, y)
        if(x>0 && y>0)
            lw.MoveTo(x,y)
            return true
        end
        n = n+1
    end
    return false
end

//用于循环的攻击操作
function option()
    //按下Tab切换目标
    var findNum = 0//记录寻找次数
    
    while(flag)
        
        lw.SetWindowState(hwnd, 1)
        while(flag)
            //如果找到了要攻击的目标,跳出循环,结束线程
            if(1 == myFindPic(getAttackTarget()))
                findNum = 0
                if(-1 != moveThreadID)
                    threadclose(moveThreadID)
                    moveThreadID = -1
                    //如果地图打开了,则关闭地图
                    if(judgeMapIsOpen())
                        lw.KeyPress(77)
                        lw.delay(100)
                    end
                end
                break
            end
            //如果找了2次没找到,判定附近没有怪,移动回锚点
            if(findNum > 4 )
                //防止开启多个线程
                if(-1 == moveThreadID)
                    moveThreadID = threadbegin("moveToPoint", "")
                end
                findNum = 0
            end
            
            lw.delay(300)
            lw.KeyPress(52)//捡拾
            lw.delay(300)
            lw.KeyPress(9)
            findNum = findNum+1
        end
        
        //按1,攻击
        lw.KeyPress(49)
        lw.delay(200)
        //        lw.KeyPress(113)//F2
        lw.delay(1000)
        lw.KeyPress(49)
        //捡拾物品
        lw.delay(200)
        lw.KeyPress(52)
        lw.delay(500)
        lw.KeyPress(52)
        lw.delay(500)
        lw.KeyPress(52)
        lw.delay(500)
        lw.KeyPress(52)
        lw.delay(500)
        lw.KeyPress(9)
        lw.delay(500)
        lw.KeyPress(52)   
        //        lw.KeyPress(52)
        //        lw.delay(2000)
        
        lw.KeyPress(52)
        
    end
end

var flag = false
功能 按钮_启动_点击()
    //这里添加你要执行的代码
    //    lw.SetDict(0, "D:/Study/TC/pic/zk.txt")
    lw.SetWindowState(hwnd, 1)
    flag = true
    option()
    
结束


功能 按钮_停止_点击()
    //这里添加你要执行的代码
    flag = false
结束
//终止热键操作
功能 热键_停止_热键()
    flag = false
    列表框增加文本("列表框_状态框", "即将停止...")
结束

//找图调试专用
function myFindPicTest(pic)
    var x=-1, y=-1, n=0
    while(n<10)
        dm.FindPic(324,168,956,804,pic, "000000", 0.5, 2, x, y)
        if(x>0 && y>0)
            lw.MoveTo(x,y)
            return 1
        end
        n = n+1
    end
    
    return 0
end
功能 按钮_找图_点击()    
    
    var attach_target = combogettext("下拉框_攻击对象")
    //        var attach_target2 = combogettext("下拉框_攻击对象2")
    if("" == attach_target)
        return
    end
    var str = getrcpath("rc:map1.bmp")&"|"&getrcpath("rc:map2.bmp")&"|"&getrcpath("rc:map3.bmp")
    //	dm.SetPath("d:\\Study\\TC\\LewaDemo\\pic")
    //        var str = "map/自己1.bmp|map/自己2.bmp"
    //        if("" != attach_target2)
    //            str = str&"|"&attach_target2&"1.bmp|"&attach_target2&"2.bmp|"&attach_target2&"3.bmp"
    //        end
    
    //    messagebox(myFindPic("加鲁鲁兽1.bmp|加鲁鲁兽2.bmp|加鲁鲁兽3.bmp"))
    //    messagebox(myFindPic(str))
    var x=-1,y=-1
    
    messagebox(myFindPicTest(str))
    //    dm.FindColor(0, 0, 2000, 2000, "7f5a54-000000|89625f-000000", 4, 0, 0, x, y)
    //    messagebox(x, y)
    
结束


function myFindSelfXY(etX, etY)	
    
    //打开地图
    lw.SetWindowState(hwnd, 1)
    lw.delay(200)
    lw.KeyPress(77)
    lw.delay(200)
    var currentX=-1, currentY=-1, n=0
    var picPath = getrcpath("rc:map_自己1.bmp")&"|"&getrcpath("rc:map_自己2.bmp")
    while(n<12)
        dm.FindPic(324,168,956,804,picPath , "000000", 0.5, 2, currentX, currentY)
        //        dm.FindPic(324,168,956,804,picPath , "000000", 0.5, 3, currentX, currentY)//银光湖
        //        dm.FindPic(466,284,826,728,picPath , "000000", 0.5, 2, currentX, currentY)//西部专用
        //精确度为0.5最佳
        if(单选框获取状态("单选框_西部巴达"))
            dm.FindPic(466,284,826,728,picPath, "000000", 0.5, 2, currentX, currentY)//西部专用
        elseif(单选框获取状态("单选框_银光比特"))
            dm.FindPic(324,168,956,804,picPath , "000000", 0.5, 3, currentX, currentY)//银光湖
        else
            dm.FindPic(324,168,956,804,picPath, "000000", 0.5, 2, currentX, currentY)
        end
        if(currentX>0 && currentY>0)
            编辑框设置文本(etX, currentX)
            编辑框设置文本(etY, currentY)
            lw.KeyPress(77)
            return 1
        end
        n = n+1
    end
    messagebox("获取当前坐标失败,请勿遮挡窗口")
    return 0
end




