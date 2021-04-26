# **I Stole a Wizard's Sack and All I Got Was This Lousy Infinite Pocket Universe** (working title)
*Ludum Dare 48 Entry - Theme: "Deeper and Deeper"*

2D top-down puzzle game with recursion, non-euclidean levels, and other head-fuckery

## Controls
- <kbd>W A S D</kbd> or arrow keys - move
- <kbd>Q</kbd> - pick up item, like a key or a bag, or set down item if one is being held, or swap with item
- <kbd>E</kbd> - interact with something like going into a bag
- <kbd>R</kbd> - restart level

## Todo

### Fix
- [ ] Resolve issue when on multiple interactable hitboxes (don't cancel if an action can be taken)
- [ ] Diagonal movement faster than lateral
- [ ] Make it so you can walk through door
- [ ] Indicators for when you cant interact with held item

### Priority
- [x] Recursive level
- [ ] Harder recursive level
- [ ] Tall walls
- [ ] Zooming animation for going into bags

### Next
- [ ] Animation for climbing up / down ladders
- [ ] More tiles, better level visuals
- [x] New golem character art
- [ ] Tutorial tell u controls
  - Show that you can't bring items up the rope
  - Show how to 
- [ ] Sound effects
- [ ] Music
- [ ] Menu screen
- [ ] Intro area
- [ ] Save progress

### Release
- [ ] See [here](https://www.reddit.com/r/godot/comments/8b67lb/guide_how_to_compress_wasmpck_file_to_make_html5/) for compressing build
- [ ] Add splash load screen
- [ ] Add icon

## Ideas
- recursive level where door is in first and key is in bag in lower, u have to bring bag with key into room with bag that goes back to start
- moving entrance point?
- story: you're a golem who awakens to an abandoned wizard house. do some really basic puzzles telling you to go and look for clues around the house. Eventually find a note that tells you to look in the bag for the key to the front door ("I must have left it in my enchanted bag, go look for it in there") and then starts the real game. Make it seem like the house scene is the start of an adventure game or something
- level with button separating two rooms, step on button and door to key opens, step again it closes. two bags go to same room at different locations
- definitely have many different bag sprites, different sash colors
- recursive level where you have to bring bags through in a particular order so you can press buttons in the right order - a passage where you have to step on the button in that room - hitting N buttons in any order but correct will reset - two versions, one where you can go back and hit the button multiple times, and one where a treadmill moves you so you can't without being the bag for the room your in with you - only one room where you can go back out? - screen or something in room that shows current combo
- holes that go straight to a particular room
- non linear but getting to the end gives u a way to skip levels you've already done?
- alternative solution: hit numbers in reverse order?
- entrance animation: zoom in, fade out bg, animate player coming down rope and dropping to floor
- moving holes
- ladder instead of rope