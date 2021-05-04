local UserInputService  = game:GetService("UserInputService")

local MaterialUI    = require(script.Parent:WaitForChild("MaterialUI"   ))
local AdvancedTween = require(script.Parent:WaitForChild("AdvancedTween"))
local UIDragger     = require(script.Parent:WaitForChild("UIDragger"    ))
local UIResizer     = require(script.Parent:WaitForChild("UIResizer"    ))

local Items            = {}
local StartWindowIndex = 50
local ResizerSize      = 10

local ClickCodes = {
	["Enum.KeyCode.Unknown"] = true;
}
local InputTypes = {
	["Enum.UserInputType.MouseButton1"] = true;
	["Enum.UserInputType.MouseButton2"] = true;
	["Enum.UserInputType.Touch"] = true;
}

local WindowClass = {
	new = function(WindowInfo)
		local Data
		
		local WindowInfo = WindowInfo or {}
		WindowInfo.WindowRoundSize = WindowInfo.WindowRoundSize or 14
		
		if Items[WindowInfo.WindowID] then
			error(tostring(WindowInfo.WindowID) .. " already exists!")
			return
		end
		
		--// UI 저장
		local Store = {
			WindowHolder = nil;
			WindowFrame  = nil;
			UIScale      = nil;
			TopBar       = nil;
			Gui          = nil;
			Shadow       = nil;
			CloseButton  = nil;
		}
		
		local ResizeHandle = {}
		
		--// UI 드로잉
		MaterialUI.Create("ScreenGui",{
			ResetOnSpawn = false;
			Name = WindowInfo.WindowTitle;
			WhenCreated = function(this)
				Store.Gui = this
				wait()
				MaterialUI:Draw(this)
			end;
			DisplayOrder = StartWindowIndex;
		},{
			WindowHolder = MaterialUI.Create("Frame",{
				BackgroundTransparency = 1;
				Size = UDim2.fromOffset(WindowInfo.WindowSize.X,WindowInfo.WindowSize.Y);
				Position = WindowInfo.WindowPosition or UDim2.new(0.5,-WindowInfo.WindowSize.X/2,0.5,-WindowInfo.WindowSize.Y/2);
				WhenCreated = function(this)
					Store.WindowHolder = this
				end;
			},{
				WindowFrame = MaterialUI.Create("ImageButton",{
					AutoButtonColor = false;
					BackgroundTransparency = 1;
					AnchorPoint = Vector2.new(0.5,0.5);
					Position = UDim2.fromScale(0.5,0.5);
					Size = UDim2.new(1,0,1,0);
					ImageColor3 = WindowInfo.Colors.Background;
					WhenCreated = function(this)
						MaterialUI:SetRound(this,WindowInfo.WindowRoundSize)
						Store.WindowFrame = this
					end;
				},{
					Scale = MaterialUI.Create("UIScale",{
						Scale = 1;
						WhenCreated = function(this)
							Store.UIScale = this
						end;
					});
					ResizerT = MaterialUI.Create("TextButton",{
						AnchorPoint = Vector2.new(0,1);
						Size = UDim2.new(1,-WindowInfo.WindowRoundSize*2,0,ResizerSize);
						Position = UDim2.fromOffset(WindowInfo.WindowRoundSize,0);
						Text = "";
						BackgroundTransparency = 1;
						ZIndex = -2;
						WhenCreated = function(this)
							ResizeHandle.T = this
						end;
					});
					ResizerB = MaterialUI.Create("TextButton",{
						Position = UDim2.new(0,WindowInfo.WindowRoundSize,1,0);
						Size = UDim2.new(1,-WindowInfo.WindowRoundSize*2,0,ResizerSize);
						Text = "";
						BackgroundTransparency = 1;
						ZIndex = -2;
						WhenCreated = function(this)
							ResizeHandle.B = this
						end;
					});
					ResizerL = MaterialUI.Create("TextButton",{
						AnchorPoint = Vector2.new(1,0);
						Position = UDim2.fromOffset(0,WindowInfo.WindowRoundSize);
						Size = UDim2.new(0,ResizerSize,1,-WindowInfo.WindowRoundSize*2);
						Text = "";
						BackgroundTransparency = 1;
						ZIndex = -2;
						WhenCreated = function(this)
							ResizeHandle.L = this
						end;
					});
					ResizerR = MaterialUI.Create("TextButton",{
						Position = UDim2.new(1,0,0,WindowInfo.WindowRoundSize);
						Size = UDim2.new(0,ResizerSize,1,-WindowInfo.WindowRoundSize*2);
						Text = "";
						BackgroundTransparency = 1;
						ZIndex = -2;
						WhenCreated = function(this)
							ResizeHandle.R = this
						end;
					});
					ResizerLT = MaterialUI.Create("TextButton",{
						AnchorPoint = Vector2.new(1,1);
						Position = UDim2.fromOffset(WindowInfo.WindowRoundSize,WindowInfo.WindowRoundSize);
						Size = UDim2.fromOffset(ResizerSize+WindowInfo.WindowRoundSize,ResizerSize+WindowInfo.WindowRoundSize);
						Text = "";
						BackgroundTransparency = 1;
						ZIndex = -2;
						WhenCreated = function(this)
							ResizeHandle.LT = this
						end;
					});
					ResizerLB = MaterialUI.Create("TextButton",{
						AnchorPoint = Vector2.new(1,0);
						Position = UDim2.new(0,WindowInfo.WindowRoundSize,1,-WindowInfo.WindowRoundSize);
						Size = UDim2.fromOffset(ResizerSize+WindowInfo.WindowRoundSize,ResizerSize+WindowInfo.WindowRoundSize);
						Text = "";
						BackgroundTransparency = 1;
						ZIndex = -2;
						WhenCreated = function(this)
							ResizeHandle.LB = this
						end;
					});
					ResizerRT = MaterialUI.Create("TextButton",{
						AnchorPoint = Vector2.new(0,1);
						Position = UDim2.new(1,-WindowInfo.WindowRoundSize,0,WindowInfo.WindowRoundSize);
						Size = UDim2.fromOffset(ResizerSize+WindowInfo.WindowRoundSize,ResizerSize+WindowInfo.WindowRoundSize);
						Text = "";
						BackgroundTransparency = 1;
						ZIndex = -2;
						WhenCreated = function(this)
							ResizeHandle.RT = this
						end;
					});
					ResizerRB = MaterialUI.Create("TextButton",{
						Position = UDim2.new(1,-WindowInfo.WindowRoundSize,1,-WindowInfo.WindowRoundSize);
						Size = UDim2.fromOffset(ResizerSize+WindowInfo.WindowRoundSize,ResizerSize+WindowInfo.WindowRoundSize);
						Text = "";
						BackgroundTransparency = 1;
						ZIndex = -2;
						WhenCreated = function(this)
							ResizeHandle.RB = this
						end;
					});
					Shadow = MaterialUI.Create("ImageLabel",{
						Size = UDim2.new(1,WindowInfo.ShadowSize.X*2,1,WindowInfo.ShadowSize.T+WindowInfo.ShadowSize.B);
						Position = UDim2.new(0.5,0,0,-WindowInfo.ShadowSize.T);
						AnchorPoint = Vector2.new(0.5,0);
						Image = "rbxassetid://1316045217";
						ZIndex = WindowInfo.ShadowIndex;
						BackgroundTransparency = 1;
						ImageColor3 = Color3.fromRGB(0,0,0);
						ImageTransparency = WindowInfo.UnfocusedShadowTransparency;
						WhenCreated = function(this)
							Store.Shadow = this
						end;
					});
					Div = MaterialUI.Create("Frame",{
						BackgroundColor3 = WindowInfo.Colors.Div;
						Size = UDim2.new(1,0,0,1);
						Position = UDim2.new(0,0,0,WindowInfo.TopBarSizeY-1);
					});
					CloseIcon = MaterialUI.Create("IconButton",{
						Icon = "http://www.roblox.com/asset/?id=6031094678";
						IconVisible = true;
						IconColor3 = WindowInfo.Colors.Icon;
						IconSizeScale = 0.85;
						Style = MaterialUI.CEnum.IconButtonStyle.WithOutBackground;
						Size = UDim2.fromOffset(WindowInfo.TopBarSizeY-8,WindowInfo.TopBarSizeY-8);
						Position = UDim2.new(1,-4,0,4);
						AnchorPoint = Vector2.new(1,0);
						ZIndex = 2;
						Visible = not WindowInfo.CloseButtonDisabled;
						MouseButton1Click = function()
							if WindowInfo.CloseFunction then
								WindowInfo.CloseFunction(Data)
								return
							end
							
							AdvancedTween:RunTween(Store.UIScale,{
								Time = 0.4;
								Easing = AdvancedTween.EasingFunctions.Exp2;
								Direction = AdvancedTween.EasingDirection.Out;
							},{
								Scale = 0.4;
							})
							AdvancedTween:RunTween(Store.WindowFrame,{
								Time = 0.4;
								Easing = AdvancedTween.EasingFunctions.Exp2;
								Direction = AdvancedTween.EasingDirection.Out;
							},{
								Position = UDim2.fromScale(0.5,1);
								AnchorPoint = Vector2.new(0.5,0);
							})
							
						end
					});
					TopBarListHolder = MaterialUI.Create("TextButton",{
						Text = "";
						BackgroundTransparency = 1;
						Size = UDim2.new(1,0,0,WindowInfo.TopBarSizeY);
						WhenCreated = function(this)
							Store.TopBar = this;
						end;
					},{
						MaterialUI.Create("UICorner",{
							CornerRadius = UDim.new(0,WindowInfo.WindowRoundSize);
						});
						MaterialUI.Create("UIListLayout",{
							SortOrder = Enum.SortOrder.LayoutOrder;
							FillDirection = Enum.FillDirection.Horizontal;
							HorizontalAlignment = Enum.HorizontalAlignment.Center;
							VerticalAlignment = Enum.VerticalAlignment.Center;
						});
						TextLabel = MaterialUI.Create("TextLabel",{
							LayoutOrder = 2;
							Text = WindowInfo.WindowTitle;
							TextSize = 18;
							Font = WindowInfo.AppFont;
							TextXAlignment = Enum.TextXAlignment.Right;
							TextColor3 = WindowInfo.Colors.Text;
							BackgroundTransparency = 1;
							WhenCreated = function(this)
								local function RefreshText()
									this.Size = UDim2.new(0,this.TextBounds.X + 6,1,0)
								end
								this:GetPropertyChangedSignal("TextBounds"):Connect(RefreshText)
								RefreshText()
							end;
						});
						Icon = MaterialUI.Create("ImageLabel",{
							Image = WindowInfo.WindowIcon;
							Size = UDim2.fromOffset(WindowInfo.WindowIconSize,WindowInfo.WindowIconSize);
							BackgroundTransparency = 1;
							LayoutOrder = 1;
							WhenCreated = function(this)
								Store.CloseButton = this
							end;
						});
					});
					Holder = MaterialUI.Create("Frame",{
						BackgroundTransparency = 1;
						Size = UDim2.new(1,0,1,-WindowInfo.TopBarSizeY);
						Position = UDim2.fromOffset(0,WindowInfo.TopBarSizeY);
						WhenCreated = function(this)
							Store.Holder = this
						end;
					});
				});
			});
		})
		
		--// 리턴값(리턴 개체) 준비
		Data = {
			Holder = Store.Holder;
			Store = Store;
			Gui = Store.Gui;
			Focused = false;
			MouseOn = false;
			InputBegan_Connection = nil;
		}
		local Resizable = WindowInfo.Resizable or false
		local CloseButtonDisabled = WindowInfo.CloseButtonDisabled or false
		local WindowMinSize = WindowInfo.WindowMinSize or {}
		
		function Data:Unfocus()
			Data.Focused = false
			Store.Shadow.ImageTransparency = WindowInfo.UnfocusedShadowTransparency
		end
		
		function Data:Focus()
			local NumWindows = 0
			for ID,Item in pairs(Items) do
				if ID ~= WindowInfo.WindowID then
					Item:Unfocus()
					
					if Item.Gui.DisplayOrder > Data.Gui.DisplayOrder then
						Item.Gui.DisplayOrder = Item.Gui.DisplayOrder - 1
					end
				end
				NumWindows = NumWindows + 1
			end
			
			Data.Gui.DisplayOrder = StartWindowIndex + NumWindows
			Store.Shadow.ImageTransparency = WindowInfo.FocusedShadowTransparency
			Data.Focused = true
		end
		
		function Data:Destroy()
			Data.Gui:Destroy()
			Items[WindowInfo.WindowID] = nil
		end
		
		function Data:SetResizable(Value)
			Resizable = Value
		end
		
		function Data:GetResizable()
			return Resizable
		end
		
		function Data:SetCloseButtonDisabled(Value)
			CloseButtonDisabled = Value
			Store.CloseButton.Visible = not Value
		end
		
		function Data:GetCloseButtonDisabled()
			return CloseButtonDisabled
		end
		
		Items[WindowInfo.WindowID] = Data
		
		--// 드래깅 활성화
		UIDragger:SetDragger(Store.TopBar,Store.WindowHolder,function()
			return true
		end)
		
		--// 리사이징 활성화
		UIResizer:SetResizer(Store.WindowHolder,{
			CheckResizable = function()
				return Resizable
			end;
			Handle = ResizeHandle;
			MinSizeX = WindowMinSize.X or 180;
			MinSizeY = WindowMinSize.Y or 180;
		})
		
		--// 이밴트 연결
		Data.MouseOn = false
		Data.InputBegan_Connection = UserInputService.InputBegan:Connect(function(Key, GameProcessedEvent)
			if ClickCodes[tostring(Key.KeyCode)] or InputTypes[tostring(Key.UserInputType)] then
				if Data.MouseOn then
					if Data.Focused then
						return
					end
					
					--// 다른 포커스된 윈도우 확인
					for ID,Item in pairs(Items) do
						if ID ~= WindowInfo.WindowID and (Item.Focused or Item.Gui.DisplayOrder > Data.Gui.DisplayOrder) and Item.MouseOn then
							return
						end
					end
					
					Data:Focus()
				else
					Data:Unfocus()
				end
			end
		end)
		
		Store.WindowHolder.MouseEnter:Connect(function()
			Data.MouseOn = true
		end)
		Store.WindowHolder.MouseLeave:Connect(function()
			Data.MouseOn = false
		end)
		
		return Data
	end;
}

return WindowClass