local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local request = ReplicatedStorage:WaitForChild("YouTubeSearchRequest")

-- Add uploaded Roblox image asset IDs here to show thumbnails for known videos.
local thumbnailAssets = {}

local colors = {
	background = Color3.fromRGB(15, 15, 15),
	bar = Color3.fromRGB(20, 20, 20),
	field = Color3.fromRGB(18, 18, 18),
	line = Color3.fromRGB(55, 55, 55),
	muted = Color3.fromRGB(170, 170, 170),
	white = Color3.fromRGB(245, 245, 245),
	red = Color3.fromRGB(255, 35, 35),
	card = Color3.fromRGB(25, 25, 25),
}

local function make(className, properties, parent)
	local object = Instance.new(className)
	for property, value in pairs(properties) do
		object[property] = value
	end
	object.Parent = parent
	return object
end

local screen = make("ScreenGui", {
	Name = "YouTubeSearchGui",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
}, player:WaitForChild("PlayerGui"))

local root = make("Frame", {
	Name = "Root",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = colors.background,
	BorderSizePixel = 0,
}, screen)

local topBar = make("Frame", {
	Name = "TopBar",
	Size = UDim2.new(1, 0, 0, 62),
	BackgroundColor3 = colors.bar,
	BorderSizePixel = 0,
}, root)

local logo = make("Frame", {
	Name = "Logo",
	Position = UDim2.fromOffset(20, 12),
	Size = UDim2.fromOffset(170, 38),
	BackgroundTransparency = 1,
}, topBar)

local playMark = make("TextLabel", {
	Position = UDim2.fromOffset(0, 2),
	Size = UDim2.fromOffset(38, 34),
	BackgroundColor3 = colors.red,
	Text = ">",
	TextColor3 = colors.white,
	TextSize = 19,
	Font = Enum.Font.GothamBold,
}, logo)
make("UICorner", { CornerRadius = UDim.new(0, 9) }, playMark)

local brand = make("TextLabel", {
	Position = UDim2.fromOffset(47, 0),
	Size = UDim2.fromOffset(120, 38),
	BackgroundTransparency = 1,
	Text = "Video Search",
	TextColor3 = colors.white,
	TextSize = 17,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
}, logo)

local searchBox = make("Frame", {
	Name = "SearchBox",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.55, 0, 0.5, 0),
	Size = UDim2.new(0.52, 0, 0, 40),
	BackgroundColor3 = colors.field,
	BorderSizePixel = 0,
}, topBar)
make("UICorner", { CornerRadius = UDim.new(0, 20) }, searchBox)
make("UIStroke", { Color = colors.line, Thickness = 1 }, searchBox)

local searchInput = make("TextBox", {
	Name = "SearchInput",
	Position = UDim2.fromOffset(16, 0),
	Size = UDim2.new(1, -110, 1, 0),
	BackgroundTransparency = 1,
	ClearTextOnFocus = false,
	Font = Enum.Font.Gotham,
	PlaceholderText = "Search YouTube",
	PlaceholderColor3 = colors.muted,
	Text = "",
	TextColor3 = colors.white,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
}, searchBox)

local searchButton = make("TextButton", {
	Name = "SearchButton",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -4, 0.5, 0),
	Size = UDim2.fromOffset(88, 32),
	BackgroundColor3 = Color3.fromRGB(45, 45, 45),
	Text = "Search",
	TextColor3 = colors.white,
	TextSize = 13,
	Font = Enum.Font.GothamMedium,
	AutoButtonColor = true,
}, searchBox)
make("UICorner", { CornerRadius = UDim.new(0, 17) }, searchButton)

local heading = make("TextLabel", {
	Name = "ResultsHeading",
	Position = UDim2.new(0, 26, 0, 73),
	Size = UDim2.new(1, -52, 0, 28),
	BackgroundTransparency = 1,
	Text = "Search for a video",
	TextColor3 = colors.white,
	TextSize = 18,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
}, root)

local results = make("ScrollingFrame", {
	Name = "Results",
	Position = UDim2.new(0, 12, 0, 112),
	Size = UDim2.new(1, -24, 1, -178),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 5,
	ScrollBarImageColor3 = Color3.fromRGB(110, 110, 110),
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.None,
}, root)

make("UIPadding", {
	PaddingLeft = UDim.new(0, 14),
	PaddingRight = UDim.new(0, 14),
	PaddingTop = UDim.new(0, 8),
	PaddingBottom = UDim.new(0, 16),
}, results)

local grid = make("UIGridLayout", {
	CellPadding = UDim2.fromOffset(16, 18),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, results)

local footer = make("Frame", {
	Name = "Footer",
	Position = UDim2.new(0, 24, 1, -54),
	Size = UDim2.new(1, -48, 0, 38),
	BackgroundTransparency = 1,
}, root)

local status = make("TextLabel", {
	Name = "Status",
	Size = UDim2.new(1, -150, 1, 0),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = colors.muted,
	TextSize = 13,
	Font = Enum.Font.Gotham,
	TextXAlignment = Enum.TextXAlignment.Left,
}, footer)

local moreButton = make("TextButton", {
	Name = "LoadMore",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, 0, 0.5, 0),
	Size = UDim2.fromOffset(132, 34),
	BackgroundColor3 = Color3.fromRGB(45, 45, 45),
	Text = "Load 20 more",
	TextColor3 = colors.white,
	TextSize = 13,
	Font = Enum.Font.GothamMedium,
	Visible = false,
}, footer)
make("UICorner", { CornerRadius = UDim.new(0, 17) }, moreButton)

local currentQuery = ""
local nextPageToken = nil
local resultCount = 0
local loading = false

local function updateGrid()
	local width = root.AbsoluteSize.X
	if width < 640 then
		brand.Visible = false
		logo.Position = UDim2.fromOffset(16, 12)
		logo.Size = UDim2.fromOffset(40, 38)
		searchBox.AnchorPoint = Vector2.new(0, 0.5)
		searchBox.Position = UDim2.new(0, 64, 0.5, 0)
		searchBox.Size = UDim2.new(1, -78, 0, 40)
	else
		brand.Visible = true
		logo.Position = UDim2.fromOffset(20, 12)
		logo.Size = UDim2.fromOffset(170, 38)
		searchBox.AnchorPoint = Vector2.new(0.5, 0.5)
		searchBox.Position = UDim2.new(0.58, 0, 0.5, 0)
		searchBox.Size = UDim2.new(0.52, 0, 0, 40)
	end

	local columns = width < 600 and 1 or (width < 1000 and 2 or 3)
	local height = width < 600 and 246 or 232
	grid.CellSize = UDim2.new(1 / columns, -18, 0, height)
end

local function updateCanvas()
	results.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y + 24)
end

local function addResult(item)
	local card = make("TextButton", {
		Name = "Video_" .. item.videoId,
		BackgroundColor3 = colors.card,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = resultCount,
	}, results)
	make("UICorner", { CornerRadius = UDim.new(0, 7) }, card)

	local imageFrame = make("Frame", {
		Name = "ThumbnailFrame",
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, 0, 0, 142),
		BackgroundColor3 = Color3.fromRGB(38, 38, 38),
		BorderSizePixel = 0,
	}, card)
	make("UICorner", { CornerRadius = UDim.new(0, 7) }, imageFrame)

	local assetId = thumbnailAssets[item.videoId]
	if assetId then
		make("ImageLabel", {
			Name = "Thumbnail",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Image = assetId,
			ScaleType = Enum.ScaleType.Crop,
		}, imageFrame)
	else
		make("TextLabel", {
			Name = "ThumbnailFallback",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -24, 0, 52),
			BackgroundTransparency = 1,
			Text = ">\nThumbnail asset not set",
			TextColor3 = Color3.fromRGB(190, 190, 190),
			TextSize = 14,
			Font = Enum.Font.GothamMedium,
		}, imageFrame)
	end

	make("TextLabel", {
		Name = "Title",
		Position = UDim2.fromOffset(10, 150),
		Size = UDim2.new(1, -20, 0, 42),
		BackgroundTransparency = 1,
		Text = item.title,
		TextColor3 = colors.white,
		TextSize = 14,
		Font = Enum.Font.GothamMedium,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	}, card)

	make("TextLabel", {
		Name = "Channel",
		Position = UDim2.fromOffset(10, 197),
		Size = UDim2.new(1, -20, 0, 22),
		BackgroundTransparency = 1,
		Text = item.channel,
		TextColor3 = colors.muted,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, card)

	card.Activated:Connect(function()
		local opened = pcall(function()
			GuiService:OpenBrowserWindow("https://www.youtube.com/watch?v=" .. item.videoId)
		end)
		if not opened then
			status.Text = "Could not open the video in a browser."
		end
	end)
end

local function search(query, pageToken)
	if loading then
		return
	end
	loading = true
	searchButton.Active = false
	moreButton.Active = false
	status.Text = "Searching YouTube..."

	local invokeOk, response = pcall(function()
		return request:InvokeServer(query, pageToken)
	end)
	if not invokeOk then
		status.Text = "Search failed. Check that the server script is running."
	elseif not response.ok then
		status.Text = response.error or "Search failed."
	else
		if not pageToken then
			for _, child in ipairs(results:GetChildren()) do
				if child:IsA("TextButton") then
					child:Destroy()
				end
			end
			resultCount = 0
			results.CanvasPosition = Vector2.zero
		end

		for _, item in ipairs(response.items) do
			resultCount += 1
			addResult(item)
		end

		nextPageToken = response.nextPageToken
		moreButton.Visible = nextPageToken ~= nil
		status.Text = resultCount == 0 and "No videos found." or ("Showing " .. resultCount .. " videos")
		if not pageToken then
			heading.Text = 'Results for "' .. query .. '"'
		end
		updateCanvas()
	end

	loading = false
	searchButton.Active = true
	moreButton.Active = true
end

local function runSearch()
	local query = string.gsub(searchInput.Text, "^%s*(.-)%s*$", "%1")
	if query == "" then
		status.Text = "Enter a search term."
		return
	end
	currentQuery = query
	nextPageToken = nil
	search(query, nil)
end

searchButton.Activated:Connect(runSearch)
searchInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		runSearch()
	end
end)

moreButton.Activated:Connect(function()
	if currentQuery ~= "" and nextPageToken then
		search(currentQuery, nextPageToken)
	end
end)

root:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateGrid)
grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
updateGrid()