# The Art of Saying No ❌
### Created by: Amina Al-Helali, Emma Souannhaphanh, Wei-Qing Gan

_The Art of Saying No_ is about learning to set boundaries by saying “**no**” to people. Players navigate an environment trapped by walls and crowded with NPCs that represent the pressure to say “yes”. As you interact with these characters and establish your boundaries by saying “**no**”, the physical walls of the environment break down until you achieve freedom in an empty canvas.
_____
<img width="1277" height="712" alt="the art of saying no gameplay" src="https://github.com/user-attachments/assets/ddec569a-9615-452b-970c-865941595455" />

### How to Run 🏃
1. Download the project and open in processing.
2. From the intro state, click ENTER to start the game.

### The Controls ⌨️
1. Mouse: Point and Click to set the locations for main character
2. Keyboard: [Enter] to start the game, [Q][W][E][R][T][Y] to select response

### Topics Implemented 💬
1. Complex Movement Algorithms: NPCs utilize a Wander algorithm to move between rooms.
2. Pathfinding: A* algorithm was used for both player movement (recalculated on every click) and NPC following (recalculated every second).
3. Decision Making: Manages states for both player (Moving and Interacting with NPCs) and NPC (Wandering, Following player, Waiting for response, Running away from player).
4. Procedural Content Generation: Perlin noise applied for noisy movement and generating pixelated terrain textures. Cellular Automata used to deteriorate walls at the end of the game.
5. Separate: NPCs avoiding bumping into each other.
6. Flee: NPCs avoid going through the walls when wandering.
7. Additional Interaction: Point and click system integrated with pathfinding for player movement. 

### How to View 👁️
1. Pathfinding/Movement: Click on white tiles on the map to see the red character (player) navigate the environment using A*.
2. Decision Making: Observe NPCs wandering until they detect the player, which they will switch to “following” to ask the player a question. Players are to make decisions using QWERTY when an NPC gets close to them and the question UI menu pops up.
3. Procedural Content Generation: The environment is generated at the start of the game and can be seen throughout the gameplay, where the wall deterioration effect is visible when player successfully rejects all of NPCs’ questions.

### Contributions 👥
👤 Amina - NPC Movement & State Machines, Game Manager (Start, Idle, End)\
👤 Emma - Game UI, Character & NPC Art + Animation, Procedural Room & Maze Generation, Explosion Effects\
👤 Qing - Player Movement & State Machines, Player Action (Point & Click)

<br>


