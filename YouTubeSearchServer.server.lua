local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:FindFirstChild("YouTubeSearchRequest")
if not remote then
	remote = Instance.new("RemoteFunction")
	remote.Name = "YouTubeSearchRequest"
	remote.Parent = ReplicatedStorage
end

local lastRequestAt = {}
local requestCooldown = 1.5

local function chooseThumbnail(thumbnails)
	if not thumbnails then
		return nil
	end

	local thumbnail = thumbnails.high or thumbnails.medium or thumbnails.default
	return thumbnail and thumbnail.url or nil
end

remote.OnServerInvoke = function(player, query, pageToken)
	if typeof(query) ~= "string" then
		return { ok = false, error = "Enter a search term." }
	end

	query = string.gsub(query, "^%s*(.-)%s*$", "%1")
	if #query == 0 or #query > 100 then
		return { ok = false, error = "Search terms must be 1 to 100 characters." }
	end

	if pageToken ~= nil and (typeof(pageToken) ~= "string" or #pageToken > 1024) then
		return { ok = false, error = "Invalid results page." }
	end

	local now = os.clock()
	local previousRequest = lastRequestAt[player.UserId] or 0
	if now - previousRequest < requestCooldown then
		return { ok = false, error = "Please wait a moment before searching again." }
	end
	lastRequestAt[player.UserId] = now

	local url = "https://www.googleapis.com/youtube/v3/search"
		.. "?part=snippet&type=video&maxResults=20&safeSearch=moderate&q="
		.. HttpService:UrlEncode(query)
	if pageToken then
		url ..= "&pageToken=" .. HttpService:UrlEncode(pageToken)
	end

	local requestOk, response = pcall(function()
		return HttpService:RequestAsync({
			Url = url,
			Method = "GET",
			Headers = {
				["x-goog-api-key"] = HttpService:GetSecret("YOUTUBE_API_KEY"),
				["Accept"] = "application/json",
			},
		})
	end)
	if not requestOk then
		warn("YouTube search request failed:", response)
		return { ok = false, error = "Could not reach YouTube. Check the API key and HTTP settings." }
	end

	if not response.Success then
		warn("YouTube API returned HTTP status", response.StatusCode)
		return { ok = false, error = "YouTube returned an error (HTTP " .. response.StatusCode .. ")." }
	end

	local decodeOk, payload = pcall(function()
		return HttpService:JSONDecode(response.Body)
	end)
	if not decodeOk or typeof(payload) ~= "table" then
		return { ok = false, error = "YouTube returned an unreadable response." }
	end

	local items = {}
	for _, result in ipairs(payload.items or {}) do
		local snippet = result.snippet
		local videoId = result.id and result.id.videoId
		if snippet and videoId then
			table.insert(items, {
				videoId = videoId,
				title = snippet.title or "Untitled video",
				channel = snippet.channelTitle or "Unknown channel",
				publishedAt = snippet.publishedAt or "",
				thumbnailUrl = chooseThumbnail(snippet.thumbnails),
			})
		end
	end

	return {
		ok = true,
		items = items,
		nextPageToken = payload.nextPageToken,
	}
end

Players.PlayerRemoving:Connect(function(player)
	lastRequestAt[player.UserId] = nil
end)