
local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)

function GameScene.create()
    local scene = GameScene.new()
    scene:addChild(scene:createLayer())
    return scene
end


function GameScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function GameScene:playBgMusic()
end

-- create layer
function GameScene:createLayer()
    --获取cocos studio创建的ui
    local rootNode = cc.CSLoader:createNode("MainScene.csb")
    
    --加载cocos studio创建的flash动画
    local tl = cc.CSLoader:createTimeline("MainScene.csb") 
    rootNode:runAction(tl) 
    tl:gotoFrameAndPlay(0,true)


    local textFields={}

  --button触摸事件函数
    local function onTouch(self,eventType)
        if eventType==2 then --0:触摸开始 1：移动中 2：触摸结束
        
           --加载音频
            AudioEngine.playMusic("disappear1.wav",false)
            
            local value=self.btnValue
            local type=self.btnType
            if type=="num" then
                demo:getAnimation():play("stand_fire",2,0)
                if textFields[2]:getString()=="" then
                    textFields[1]:setString(textFields[1]:getString() .. value)
                else
                    textFields[3]:setString(textFields[3]:getString() .. value)
                end
            elseif type=="operation" then
                demo:getAnimation():play("walk_fire",1,0)
                if textFields[1]:getString()~="" then
                    textFields[2]:setString(value)
                end
            elseif type=="result" then
                if value=="clear" then
                    demo:getAnimation():play("killall",4,0)
                    for k,v in pairs(textFields) do
                        v:setString("")
                    end

                end
                if value=="equal" then
                    demo:getAnimation():play("hitted",2,0)
                    local result
                    if textFields[2]:getString()=="+" then
                        result=tonumber(textFields[1]:getString()) + tonumber(textFields[3]:getString())
                    end
                    if textFields[2]:getString()=="-" then
                        result=tonumber(textFields[1]:getString()) - tonumber(textFields[3]:getString())
                    end
                    if textFields[2]:getString()=="*" then
                        result=tonumber(textFields[1]:getString()) * tonumber(textFields[3]:getString())
                    end
                    if textFields[2]:getString()=="/" then
                        result=tonumber(textFields[1]:getString()) / tonumber(textFields[3]:getString())
                    end
                    textFields[4]:setString(result)
                end
            end
        end
    end
   --获得button，并绑定触摸事件
    local btnItems=rootNode:getChildren()
    local num_0=rootNode:getChildByName("num_0")
    local count=1
    for k,v in pairs(btnItems) do
        local btnItem=v:getName()
        local btnType=string.sub(btnItem,1,string.find(btnItem,"_")-1)
        local btnValue=string.sub(btnItem,string.find(btnItem,"_")+1 ,-1)
        if btnType=="num" or btnType=="operation" or btnType=="result" then
            v.btnType=btnType
            v.btnValue=btnValue
            v:addTouchEventListener(onTouch)
        elseif btnType=="Text" then
            textFields[count]=v
            count=count+1
        end
    end 
   --加载骨骼动画
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("DemoPlayer/DemoPlayer0.png","DemoPlayer/DemoPlayer0.plist","DemoPlayer/DemoPlayer.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("DemoPlayer/DemoPlayer1.png","DemoPlayer/DemoPlayer1.plist","DemoPlayer/DemoPlayer.ExportJson")
    demo=ccs.Armature:create("DemoPlayer") 
    demo:setPosition(390,250)
    demo:setScale(0.05)
    demo:getAnimation():play("stand",4,1)

    rootNode:addChild(demo)
    return rootNode
end

return GameScene
