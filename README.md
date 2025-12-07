# HotTomatoid - KDE Plasma Timer Widget

KDE Plasma plasmoid for Pomodoro timer with fast and simple management.

You can EZ adjust the current time slot for work or rest using the scroll wheel or touchpad.

Try to catch a work-life balance!

## Особенности

- Displays a countdown timer on the taskbar
- Start/stop the timer with a mouse click
- The countdown starts at 35 minutes, but with one turn of the wheel you set how much you need.
- When 00:00 is reached, the timer will show a splashscreen with ajusteble timer.
- Compact
- Can be placed on the taskbar or on the Desktop.


## INSTALL
Just drug&drop HotTomatoid.plasmoid to your Task Panel.
Or run install.sh 

## Build and install (for developers)

1. First, build the package using a script:

```bash
./build_package.sh
./install.sh
```

This will create the file `HotTomatoid.plasmoid' and will install this.

2. Install the package using one of the following methods:

**Method 1: Via the command line**
```bash

#To update an already installed plasmoid:
#Upgrade
plasmapkg2 -u HotTomatoid.plasmoid

#install
plasmapkg2 -i HotTomatoid.plasmoid
# or immediately add to the panel
plasmapkg2 -t plasmoid -i HotTomatoid.plasmoid 

# and immediately restart KDE without logoff
kquitapp5 plasmashell && plasmashell &
```

**Method 2: Through the file manager**
Just double-click on the file `HotTomatoid.plasmoid`
This method may not work, depending on your settings.

3. After installation:

- Right-click on the taskbar
- Select "Add Widgets..."
- Find the HotTomatoid in the list
- Drag it to the taskbar

## Usage

- **Widget click**: Start/stop timer
- The timer starts counting down from 35:00, but with one turn of the wheel you set how much you need.
- When 00:00 is reached, the timer will show a splashscreen with ajusteble timer.


## delete 
plasmapkg2 -t plasmoid -r org.kde.plasma.hottomatoid
kquitapp5 plasmashell && plasmashell &

## Project structure

```
HotTomatoid/
├── build_package.sh # Script for building the package
├── install.sh # Script for install.
,── README.md # This file
└── hottomatoid/
    └── package/
        ├── metadata.json # Plugin metadata
        └── contents/
            └── ui/
                ,── main.qml # Main interface file
```

## Requirements

- KDE Plasma 5.12 or later
- Qt 5.12 or later

## License

MIT License