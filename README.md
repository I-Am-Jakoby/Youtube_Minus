# Youtube_Freemium

[Last 10 Videos Website Example](https://i-am-jakoby.github.io/Youtube_Minus/) <-- Example of loading results into a webpage as a way to promote your last 10 videos Ad FREE

---

# Syntax 

## This loads the functions you need into your console 

`Invoke-RestMethod https://jakoby.lol/ytfreemium` <-- use this to look at the code without executing it

```powershell
Invoke-RestMethod https://jakoby.lol/ytfreemium | Invoke-Expression
```

---

## Watch individual video
```powershell
watchvideo -url "https://www.youtube.com/watch?v=VJVrzAeH-0I"
```

---

## Watch newest video from specific creator
```powershell
watchvideo -creator iamjakoby
```

---

## Watch last X amount of videos from specific creator
```powershell
watchVideo -creator NetworkChuck -maxResults 4
```

---

## Get New Video From all Creators on List

Watch the newest video from all creators in specified list (Ex list below)

With future plans of being able to load in custom lists general hacking, bug bounties, malware research etc 

Does not have to stay in cyber either, make custom music lists etc

```powershell
$channels         = @{
    NetworkChuck = "UC9x0AN7BWHpCDHSm9NiJFJQ"
    JohnHammond  = "UCVeW9qkBjo3zosnqUbG7CFw"
    Stok         = "UCQN2DsjnYH60SFBIA6IkNwg"
    Hak5         = "UC3s0BtrBJpwNDaflRSoiieQ"
    Nahamsec     = "UCCZDt7MuC3Hzs6IH4xODLBw"
    Zsecurity    = "UCVPjtOVcnKaSRI8IO3KSetA"
    Sasquach     = "UCUoJk48pujh29p8zLsnD5PQ"
    iamjakoby    = "UCQUz2mC5Regc63XRWEqD9FA"    
}
```

```powershell
watchVideo -creator all
```

---

## CLI Format

This function will return an object with some basic information on the creators newest video 

This gives you an idea of the variables we can play with for future functions 

Getting only live videos from a list of creators 

Getting only videos posted today from a list of creators etc 

---

```
newvideo -creator JohnHammond
```

```powershell
ChannelName : John Hammond
VideoID     : zs86OYea8Wk
VideoTitle  : Getting Started in Firmware Analysis &amp; IoT Reverse Engineering
IsLive      : none
Description : https://j-h.io/bugprove || For blazing-fast automated IoT firmware analysis and zero-day discovery, you
              can use BugProve FOR ...
Published   : 5/11/2023 1:00:43 PM
```

---

## Get-ChannelID 

Use this to get a youtube Channel ID from a youtube url
```powershell
$channelURL = "https://www.youtube.com/iamjakoby"
    
$pageInfo = Invoke-RestMethod $channelURL
    
Get-ChannelID -channelURL $pageInfo
```
