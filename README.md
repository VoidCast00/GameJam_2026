# 2D Game 

```
game/
│
├── addons/                  → Plugins from the Asset Library or other sources
│
├── assets/                  → All raw art, sound and visual files
│   ├── sprites/
│   │   ├── player/          → Player character images and animations
│   │   ├── enemies/         → Enemy images and animations
│   │   ├── items/           → Pickups, weapons, collectibles
│   │   └── environment/     → Trees, rocks, props, backgrounds
│   ├── tilesets/            → Tile images and tileset resources
│   ├── ui/                  → Buttons, icons, menu graphics, themes
│   ├── fonts/               → Font files
│   ├── audio/
│   │   ├── music/           → Background music
│   │   └── sfx/             → Sound effects
│   ├── shaders/             → Visual effect shaders
│   └── particles/           → Particle textures and effects
│
├── scenes/                  → Game scenes, with their scripts kept next to them
│   ├── main/                → The starting scene of the game
│   ├── player/              → Everything for the player character
│   ├── enemies/             → One subfolder per enemy type
│   ├── items/               → Pickups and interactable objects
│   ├── levels/              → Level and map scenes
│   ├── ui/                  → Menus, HUD, pause screen, game over screen
│   └── components/          → Reusable parts (health, hitbox, etc.)
│
├── scripts/                 → Scripts that don't belong to one specific scene
│   ├── autoload/            → Global managers (game state, audio, saving, scene switching)
│   ├── resources/           → Custom data type definitions
│   └── utils/               → General helper functions
│
├── data/                    → Game data (item stats, enemy stats, dialogue)
│
├── localization/            → Translation files (optional)
│
└── tests/                   → Automated tests (optional)
```
