# Skellix's Custom Dialogue Script

This is a custom dialogue script for FNF Psych Engine, created by [Skellix](https://www.youtube.com/@skellix_), now uploaded to a github page.

If you use this, credit him for his work.

`skellix::skellix::created the dialogue script::https://www.youtube.com/@skellix_::57f281`

In order to use without autodetect, simply remove or deactivate the `onStartCountdown()` function.

To use it as if it were a function, you just have to go to your dialogue script [I recommend starting [here](https://shadowmario.github.io/psychengine.lua/pages/snippets.html)] and replace `startDialogue('dialogue')` with `runTimer('startDialogue', 0.8);`. It is also recommended to add `setProperty('inCutscene', true);` to avoid any camera movement just before the first textbox appears.

## INFO

- Tested on Psych v0.7.3, will not work on 1.0
    - However, it does work with latest P-Slice engine build
- Skellix only posted this in his discord server so I, bobbyDX, am uploading this to GitHub as both an archive and a viable download for those who don't have Discord.

## Usage Guide

Just download the code as a `.zip` file and put it in your psych engine mod folder. Simple as that!