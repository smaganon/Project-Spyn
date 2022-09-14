# Project-Spyn
Final Project - Group 5
Description of Car Behavior:
    -If the touch sensor was pressed:
        Then, back up and turn right. 
    -While color is equal to black, unknown, white (the reason for the white is because our color sensor has been acting really faulty and was detecting white when the 
    color is black). 
        Move forward when the average distance is between 7 and 25. 
    -Correct away from the left wall (correcting right) if the average distance is less than 10 or greater than 240. 
    -Correct more towards the left wall (correcting left) if the average distance is between 20 and 25. 
    -Correcting a hard left if the average distance is greater than 25. 
    -While color is equal to green or blue. 
        Transition into manual mode and depending on the color, drop off the vehicle or pick up the wheelchair. 
    -Exit manual mode by pushing p. 
    -While color is equal to yellow.
        Start navigation 
    -Or if ‘u’ was pressed (after the vehicle was dropped off) it’ll exit the code entirely. 
