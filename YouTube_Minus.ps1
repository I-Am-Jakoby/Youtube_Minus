$webpage = "$env:tmp/MustWatchVids.html"

$channels         = @{
    NetworkChuck = "UC9x0AN7BWHpCDHSm9NiJFJQ"
    JohnHammond  = "UCVeW9qkBjo3zosnqUbG7CFw"
    Stok         = "UCQN2DsjnYH60SFBIA6IkNwg"
    Hak5         = "UC3s0BtrBJpwNDaflRSoiieQ"
    #Nahamsec     = "UCCZDt7MuC3Hzs6IH4xODLBw"
    Zsecurity    = "UCVPjtOVcnKaSRI8IO3KSetA"
    Sasquach     = "UCUoJk48pujh29p8zLsnD5PQ"
    iamjakoby    = "UCQUz2mC5Regc63XRWEqD9FA"    
}


function Get-ChannelID {
    param (
        [Parameter(Mandatory = $true)]
        [string]$channelURL
    )

	$pageInfo = Invoke-RestMethod $channelURL 
    $pattern = 'channel_id=([a-zA-Z0-9_-]+)'
    $match = [regex]::Match($channelURL, $pattern)

    if ($match.Success) {
	    $channelID = $match.Groups[1].Value
	    cls
        return "Channel ID:  $channelID"
    } else {
        throw "Channel ID not found in the input string."
	}
}

function Get-YouTubeVideoID {
    param (
        [Parameter(Mandatory = $true)]
        [string]$videoURL
    )

    $html = Invoke-WebRequest -Uri $videoURL
    $pattern = 'videoId":"([a-zA-Z0-9_-]+)"'
    $match = [regex]::Match($html.Content, $pattern)

    if ($match.Success) {
        $videoID = $match.Groups[1].Value
        return $videoID
    } else {
        throw "Video ID not found in the input URL."
    }
}

function newVideo {
	
	[CmdletBinding()]
	param (
		[parameter(Position=0,Mandatory=$False)]
		[ValidateSet('NetworkChuck', 'JohnHammond', 'Stok', 'Hak5', 'Nahamsec', 'Zsecurity','Sasquach', 'iamjakoby', 'all')]
		[string]$creator,		

		[parameter(Position=1,Mandatory=$False)]
		[string]$maxResults = 1,

		[parameter(Position=2,Mandatory=$False)]
		[string]$channelPage = "https://raw.githubusercontent.com/I-Am-Jakoby/Youtube_Minus/main/channelPages/defaultChannels.ps1"

 )

# ----------------------------------------------------------------------------------------------
#Invoke-RestMethod $channelPage | Invoke-Expression

$channelID = $channels.$creator
# ----------------------------------------------------------------------------------------------

	$headers=@{}
	$headers.Add("X-RapidAPI-Key", "85a64d925bmsh374c814867fca19p1c3880jsn5cff8c77bdb3")
	$headers.Add("X-RapidAPI-Host", "youtube-v31.p.rapidapi.com")
	
	$response = Invoke-RestMethod -Uri "https://youtube-v31.p.rapidapi.com/search?channelId=$channelID&part=snippet%2Cid&order=date&maxResults=$maxResults" -Method GET -Headers $headers


	$videoObject = [PSCustomObject]@{
		ChannelName = $response.items.snippet.channelTitle
		VideoID     = $response.items.id.videoId
		VideoTitle  = $response.items.snippet.title
		IsLive      = $response.items.snippet.liveBroadcastContent
		Description = $response.items.snippet.description
		Published   = $response.items.snippet.publishedAt
	}
	
	return $videoObject
}

function displayVideos {
$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
	html {
	    scroll-behavior: smooth;
	}
        body {
            font-family: Arial, sans-serif;
            background-color: #030303;
            margin: 0;
            padding: 0;
        }

        .button-container {
            display: flex;
            justify-content: center;
            padding: 16px;
        }

        .button {
            border: none;
            color: white;
            padding: 15px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
        }


        .green {
            background-color: #10471a;
        }

        .blue {
            background-color: #076ce8;
        }

        .red {
            background-color: #e80707;
        }

        .media-scroller {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 16px;
            padding: 16px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .media-item {
            width: 100%;
            max-width: 560px;
            height: 315px;
            border: 0;
            border-radius: 5px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>

	<div style="text-align: center; color: white;">
	    <h2 class="title">Enjoy Your Ad Free Viewing Brought to you by:</h2>
	    <img src="https://github.com/I-Am-Jakoby/Youtube_Minus/blob/main/Assets/logo-100x.png?raw=true" alt="Description of the image">
	    <p>Please consider supporting me here:</p>
	</div>

    <div class="button-container">
        
        <a href="https://pay.iamjakoby.com/" style="text-decoration: none;">
            <button class="button red">Tip Me</button>
        </a>
            
        <a href="https://github.com/sponsors/I-Am-Jakoby" style="text-decoration: none;">
            <button class="button red">Github</button>
        </a>
        
        <a href="https://discord.com/servers/i-am-jakoby-495265922135621632" style="text-decoration: none;">
            <button class="button red">Discord</button>
        </a>
        
        <a href="https://youtube.com/iamjakoby?sub_confirmation=1" style="text-decoration: none;">
            <button class="button red">YouTube</button>
        </a>
         
        <a href="https://twitter.com/I_Am_Jakoby" style="text-decoration: none;">
            <button class="button red">Twitter</button>
        </a>
                   
    </div>


    <div class="media-scroller">
"@

foreach ($videoID in $urlList) {
    $iframe = "<iframe class='media-item' src='https://www.youtube.com/embed/$videoID' allowfullscreen></iframe>"
    $html += $title + $iframe
}


    $html += @"
    </div>
</body>
</html>
"@

    Set-Content -Path $webpage -Value $html
    Start-Process $webpage
}

function watchVideo {

	[CmdletBinding()]
	param (
		[parameter(Position=0,Mandatory=$False)]
		[ValidateSet('NetworkChuck', 'JohnHammond', 'Stok', 'Hak5', 'Nahamsec', 'Zsecurity','Sasquach', 'iamjakoby', 'all')]
		[string]$creator,		

		[parameter(Position=1,Mandatory=$False)]
		[string]$maxResults = 1,
		
		
		[parameter(Mandatory=$False)]
		[string]$url
		)
				
$urlList = @()
if ($creator) {foreach($id in (newvideo -creator $creator -maxResults $maxResults).videoID){$urlList += $id}}

if ($url) {$id = Get-YouTubeVideoID -videoURL $url; $urlList += $id}

if ($creator -eq 'all') {
    foreach ($name in $channels.keys) {
        if ($name -ne 'all') {
            $urlList += (newvideo -creator $name).videoID
        }
    }
}
displayVideos
}
