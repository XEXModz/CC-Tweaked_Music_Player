# CC:Tweaked Music Player

A music player for [CC:Tweaked](https://tweaked.cc/) that lets you play DFPWM audio in Minecraft through connected speaker peripherals.

The player downloads its music library directly from GitHub, so songs are retrieved automatically without manually transferring audio files to your CC:Tweaked computer.

The player program is distributed through Pastebin, while GitHub hosts the song index and audio files.

## Installation

**Note:** HTTP access is enabled by default in CC:Tweaked. If HTTP access has been disabled in your configuration, you'll need to enable it before installing the player.

Open the CC:Tweaked computer terminal and run:

```lua
pastebin get mtcPsgPc ccplayer
```

This downloads the player program from Pastebin and saves it as `ccplayer`.

You can change `ccplayer` to any filename you prefer.

## Starting the Player

Run the program using the filename you chose during installation:

```lua
ccplayer
```

The player will retrieve the song index from GitHub and load the available music.

## Requirements

- Minecraft with CC:Tweaked installed.
- A CC:Tweaked computer with HTTP access enabled.
- At least one connected speaker peripheral.
- An internet connection to access Pastebin and GitHub.
- An attached monitor is optional and can be used for the player interface.

## Player Features

- Interactive song selection.
- Automatic music downloads from GitHub.
- Paginated song list.
- Shuffle playback.
- Loop modes: Off, All, and One.
- Playback controls, including pause, resume, and skip.
- Adjustable volume.
- Optional monitor support for the player interface.

## Use Your Own Music Library

You can host your own DFPWM music files on GitHub and configure the player to use your music library.

### 1. Create Your Music Repository

Fork this repository or create your own GitHub repository.

Your music repository only needs:

- `index.txt` — the list of songs available to the player.
- Your `.dfpwm` audio files.

**You do not need to upload `PASTEBINCODE.lua` to your music repository.** The player program is downloaded separately from Pastebin.

### 2. Add Your Audio Files

Convert your music into DFPWM format. You can use [DfpwmForge](https://github.com/XEXModz/DfpwmForge) to convert MP3 files.

Upload your converted `.dfpwm` files to the root of your GitHub repository.

### 3. Create Your Song Index

Create an `index.txt` file containing the names of your audio files, without the `.dfpwm` extension.

For example:

```lua
{
    "V My First Song",
    "V My Second Song",
    "V My Third Song"
}
```

Each entry must match its corresponding audio filename exactly.

For the example above, your repository should contain:

```text
index.txt
V My First Song.dfpwm
V My Second Song.dfpwm
V My Third Song.dfpwm
```

### 4. Configure the Player to Use Your Repository

Open `PASTEBINCODE.lua` and locate the two GitHub URLs:

- The URL used to download `index.txt`.
- The URL used to download individual `.dfpwm` files.

Change both URLs to point to your own GitHub repository and branch.

Save your changes.

### 5. Upload Your Modified Player to Pastebin

Upload your modified `PASTEBINCODE.lua` to [Pastebin](https://pastebin.com/).

Once uploaded, Pastebin will provide an ID for your player.

Install your customized player on a CC:Tweaked computer using:

```lua
pastebin get YOUR_PASTEBIN_ID ccplayer
```

Replace `YOUR_PASTEBIN_ID` with your own Pastebin ID.

Your customized player will now retrieve songs from your own GitHub music library.

---

**Enjoy your music!**
