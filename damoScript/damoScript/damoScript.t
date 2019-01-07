var 线程ID
//从这里开始执行
function 执行()
    //从这里开始你的代码
end
//启动_热键操作
function 启动_热键()
    线程ID=threadbegin("执行","")
    dmReg()
end

//终止热键操作
function 终止_热键()
    threadclose(线程ID)
end

//大漠注册
//189134796264a3f7ddb03ea56e9b8219e0ae60c6549
//zhoulize77b6399c11605f7149c4f4e47423dbd0 
var dm
var hwnd
function dmReg()
    var dmRegPath = getrcpath("rc:DmReg.dll")
    var dmPath = "D:/dm/dm.dll"
    
    //    注册插件(dmPath, true)
    //免注册调用
    var ea = dllcall(dmRegPath,"int","SetDllPathA","char *",dmPath,"int",0)//免注册调用大漠
    traceprint(ea)
    dm = com("dm.dmsoft")//存放大漠对象
    traceprint(dm.ver())
    if(dm != null)
        messagebox("注册成功")
    else
        messagebox("注册失败")
    end
end

//注册调用
function dm()
    regdll("rc:dm.dll", true)
    dm = com("dm.dmsoft")//存放大漠对象
    traceprint(dm.ver())
    if(dm != null)
        messagebox("注册成功")
    else
        messagebox("注册失败")
    end
end

function btn_start_点击()
    
    if(dm == null)
        messagebox("请先注册")
        return
    end
    
    var x = 10
    var y =10
    
    
    //找图
    //    dm.FindPic(0, 0, 2000, 2000, "d:/1.bmp", "000000", 0.9, 0, x, y)
    
    
    //找字
    //    dm.SetPath("d:/")
    //    dm.SetDict(0, "D:/Study/TC/pic/zk.txt")    
    //    dm.FindStr(0,0,2000, 2000, "此电脑", "ffffff-000000", 0.8, x, y)
    //操作
    //    sleep(1000)
    //    dm.LeftClick()
    
end


function 按钮_注册_点击()
    //    dmReg()
    dm()
end


function 按钮_绑定_点击()
    if(!isRegister())
        return
    end
    
    hwnd = dm.FindWindow("DMO", "DMO")
    dm.MoveWindow(hwnd, 0, 0)
    var pic = combogettext("下拉框_图色")
    var mouse = combogettext("下拉框_鼠标")
    var keymap = combogettext("下拉框_键盘")
    var mode = combogettext("下拉框_mode")
    messagebox(pic&"+"&mouse&"+"&keymap)
    var dm_hwnd = dm.BindWindow(hwnd, pic, mouse, keymap, mode)
    traceprint("绑定结果:"&dm_hwnd)
    //    if(dm_hwnd == 1)
    //        messagebox("绑定成功")
    //    else
    //        messagebox("绑定失败")
    //    end
    
    
end


function 按钮_截图_点击()
    if(!isRegister())
        return
    end
    //截图
    dm.SetPath("d:/")
    dm.Capture(0,0,2000,2000,"screen.bmp")
end

function isRegister ()
    if(dm == null)
        messagebox("请先注册")
        return false
    end
    return true
end


function 按钮_解绑_点击()
    //这里添加你要执行的代码
    if(dm == null)
        messagebox("请先注册")
        return false
    end
    var res = dm.UnBindWindow()
    messagebox("解绑结果:"&res)
end


function 按钮_找图_点击()
    //这里添加你要执行的代码
    dm.SetPath("d:")
    var x=0, y=0
    dm.FindPic(0,0,2000,2000,"damen.bmp", "000000", 0.8, 0, x, y)
    messagebox(x, y)
end
