# Roblox YouTube Search

A Roblox search UI backed by YouTube Data API v3. It shows up to 20 results per page and can request another page. Selecting a result opens its YouTube page in a browser; videos do not play inside Roblox.

## Install

1. In Roblox Studio, put `YouTubeSearchServer.server.lua` in `ServerScriptService`.
2. Put `YouTubeSearch.client.lua` in `StarterPlayer > StarterPlayerScripts` as a `LocalScript`.
3. In Game Settings, enable **Allow HTTP Requests**.
4. Enable the YouTube Data API v3 for a Google Cloud project and create an API key.
5. Add the key as a Roblox secret named `YOUTUBE_API_KEY`, permitted for `www.googleapis.com`. Do this in the experience's Creator Dashboard secrets settings. Do not put the key in the LocalScript.
6. Open or create the experience in Roblox Studio, then add the two scripts to the locations in steps 1 and 2.
7. In Studio, choose **File > Publish to Roblox**. For a new experience, choose **File > Publish to Roblox As...** and select or create the destination experience.
8. Test the published experience. Studio testing also requires the secret to be available to the experience. To make it publicly playable, update its access settings in Creator Dashboard.

Each search page uses one YouTube `search.list` request (20 results; typically 100 quota units). The server applies a short per-player request cooldown.

## Thumbnail and playback limits

The API returns thumbnail URLs, but Roblox's `ImageLabel` cannot render arbitrary external image URLs. The UI therefore shows a placeholder unless you upload a thumbnail to Roblox and map that video's ID in the `thumbnailAssets` table near the top of the LocalScript, for example:

```lua
local thumbnailAssets = {
	["VIDEO_ID"] = "rbxassetid://1234567890",
}
```

Roblox also does not provide an in-experience YouTube player. Result cards open the video page in a browser instead.
