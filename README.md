Slopwash rewrite: 80 → 80

# CC:Tweaked Music Player

A music player for [CC:Tweaked](https://tweaked.cc/) that plays DFPWM audio in Minecraft through connected speaker peripherals.

The player downloads its music library from GitHub, so you don't have to transfer audio files to your CC:Tweaked computer by hand.

The player program is distributed through Pastebin. GitHub hosts the song index and audio files.

## Installation

**Note:** HTTP access is enabled by default in CC:Tweaked. If your configuration has disabled it, enable it before installing the player.

Open the CC:Tweaked computer terminal and run:

```lua
pastebin get mtcPsgPc ccplayer
```

This downloads the player program from Pastebin and saves it as `ccplayer`.

You can rename `ccplayer` to any filename you like.

## Starting the Player

Run the program using the filename you chose during installation:

```lua
ccplayer
```

The player retrieves the song index from GitHub and loads the available music.

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

To create your own music library, use the `ForkMe` branch of this repository.

### 1. Fork the Repository

[Open the ForkMe branch](https://github.com/XEXModz/CC-Tweaked_Music_Player/tree/ForkMe) and click **Fork** to make your own copy.

In your fork, select the `ForkMe` branch.

### 2. Add Your Music

Upload your `.dfpwm` files to the root of your repository.

**All audio filenames must begin with `V ` (the letter V followed by a space).**

Edit `index.txt` and list your songs without the `.dfpwm` extension:

```lua
{
    "V My First Song",
    "V My Second Song",
    "V My Third Song"
}
```

Keep the `V ` prefix, and make sure each entry matches its audio filename.

You can convert MP3 files with [DfpwmForge](https://github.com/XEXModz/DfpwmForge).

Your repository should look something like this:

```text
CC-Tweaked_Music_Player/
├── README.md
├── V My First Song.dfpwm
├── V My Second Song.dfpwm
├── V My Third Song.dfpwm
└── index.txt
```

`PASTEBINCODE.lua` does not need to be in your GitHub repository. Once you customize it and upload it to Pastebin, the player is distributed through Pastebin, and GitHub only needs to host your music files and `index.txt`.

### 3. Configure the Player

Open `PASTEBINCODE.lua` and replace both GitHub URLs with your repository details.

**Song index:**

```text
https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPOSITORY/refs/heads/ForkMe/index.txt
```

**Audio files:**

```text
https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPOSITORY/refs/heads/ForkMe/
```

Replace `YOUR_USERNAME` and `YOUR_REPOSITORY` with your GitHub details. Save your changes.

### 4. Upload Your Player

Upload your modified `PASTEBINCODE.lua` to [Pastebin](https://pastebin.com/).

Install it on your CC:Tweaked computer with your new Pastebin ID:

```lua
pastebin get YOUR_PASTEBIN_ID ccplayer
```

Your player now uses your own GitHub music library.

---

**Enjoy your music!**
