METAGAME README/COLLABORATIVE LOG
=====================================================
Welcome to the metagame "chat" file: a collaborative
manual and log. every time there's a feature added, a
sprite added, whatever, make an addition, and change
the version number. For small changes (adding a
sprite, tweaking the player's running speed, changing
text, fixing a bug) change the last number, for medium
edits (adding a new object, drastically changing
behaviour, anything that's serious) change the middle
number. The first number is for milestones, which we
need to work out.
							-Geti

CURRENT KEYBINDINGS:
	left arrow  : walk left
	right arrow : walk right
	Z	: jump
	X	: crouch

CHANGELOG --------------------------------------------

 +-----------------------------------
 | v0.0.4 - WORKING LEVELS! BUGS - GETI
 +-----------------------------------
 
-level and screen objects fixed!
-player collision gimped
-still need to do movement between screens

 +-----------------------------------
 | v0.0.4a - MUCH BUGS - GETI
 +-----------------------------------
 
-level and screen objects broken - ARRAYS NEED WORK
-playstate _should_ work once the levels are there
-still need to do movement between screens

 +-----------------------------------
 | v0.0.3 - DETERMINISM + PHYSICS - MATT
 +-----------------------------------
 
-logic is now executed on a deterministic
	per-frame basis (hacky flixel src mod)
-player physics and control updated
-crouching added
-collision code moved

 +-----------------------------------
 | v0.0.2 - LEVEL + SCREEN OBJECTS - GETI
 +-----------------------------------
 
-level and screen objects almost done
-still need to get PlayState using levels
	not a static FlxTileMap
-also need to do movement between screens

 +-----------------------------------
 | v0.0.1 - STATIC LVL + PHYSICS - GETI
 +-----------------------------------
 
-static level added
-changed jump key (for orange)
-lots of changes to the player object
-beginnings of physics

 +-----------------------------------
 | v0.0.0 - INITIAL BUILD - GETI
 +-----------------------------------
 
-flixel integration
-haven't removed the flixel menus yet
-player object drafted
-level object semi-drafted, left it.
-player frames WIP
-menu state
-play state
-got F04_B, an awesome font.
-started!
