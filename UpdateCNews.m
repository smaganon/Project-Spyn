global key
InitKeyboard();
j = 0; %only want to play low batt warning once
brick.SetColorMode(2,2); %sets color sensor to Color Code
manualMode = false;
droppedOff = 0;
amotor = 42;
dmotor = 40;
% 0 = unknown
% 1 = black
% 2 = blue = drop off
% 3 = green = pickup
% 4 = yellow = start nav
% 5 = red = stop for 4 seconds
% 6 = white
% 7 = brown

while 1
        if key == 'n' %exits overall loop 
           brick.StopMotor('AD','Coast')
           break
        end
     

       if key == 'a' %auto mode
           disp("Entered automatic mode");
           while 1
               if key == 'p'
                       brick.StopMotor('AD','Coast')
                       disp("Exiting automatic mode");
                       break
               end
               color = brick.ColorCode(2);
               %takes average distance readings over 1.5 seconds
               %for better stability
               d1 = brick.UltrasonicDist(3);
               pause(.25);
               d2 = brick.UltrasonicDist(3);
               pause(.25);
               d3 = brick.UltrasonicDist(3);
               
               if d1 > 240
                   disp(d1)
                   d1 = 0;
               end
               if d2 > 240
                   disp(d2)
                   d2 = 0;
               end
               if d3 > 240
                   disp(d3)
                   d3 = 0;
               end
               avgDist = (d1 + d2 + d3) / 3;
               %check if we are hitting a wall before executing next code
               readTouch = brick.TouchPressed(1);
               if color == 4 && droppedOff == 1 %%if we dropped off and reached yellow, we are done
                   break;
               end
               if color == 0 || color == 1 || color == 4 %traverse the maze/no colors yet
                   if readTouch == 1 
                       brick.StopMotor('AD','Coast')
                       brick.MoveMotor('A', amotor) %move backwards
                       brick.MoveMotor('D', dmotor)
                       pause(1.3)
                       brick.StopMotor('AD','Coast')
                       %pause(.25)
                       
                       if avgDist >= 55
                           brick.MoveMotor('A',-25) %turn left
                           brick.MoveMotor('D',-75)
                       elseif avgDist < 55 %turn right
                           brick.MoveMotor('A',-75)
                           brick.MoveMotor('D',-25)
                       end
                       pause(.8)
                       brick.StopMotor('AD','Coast')
                       color = brick.ColorCode(2);
                       continue;
                   else %read touch = 0 then navigate forward
                       if avgDist >= 10 && avgDist <= 25
                           disp("Moving Forward")
                           disp(avgDist)
                           brick.MoveMotor('A', -amotor)
                           brick.MoveMotor('D', -dmotor)
                       elseif avgDist < 10 || avgDist > 240   %%correct back to left by making amotor faster
                           disp("Correcting Right")
                           disp(avgDist)
                           brick.MoveMotor('A', amotor)
                           brick.MoveMotor('D', dmotor)
                           pause(.25)
                           brick.MoveMotor('A', -amotor - 7) 
                           brick.MoveMotor('D', -dmotor)
%                            pause(.25)
%                            brick.MoveMotor('A', -amotor) 
%                            brick.MoveMotor('D', -dmotor - 10)
                       elseif avgDist > 20 && avgDist <= 25 %correct back to right by making dmotor faster
                           disp("Correcting Left")
                           disp(avgDist)
                           brick.MoveMotor('A', -amotor)
                           brick.MoveMotor('D', -dmotor - 3)
%                            pause(.25)
%                            brick.MoveMotor('A', -amotor -5)
%                            brick.MoveMotor('D', -dmotor)
                       elseif avgDist > 25 %&& avgDist <= 30
                           disp("Correcting Hard Left")
                           disp(avgDist)
                           brick.MoveMotor('A', -amotor/1.5 + 0)
                           brick.MoveMotor('D', -dmotor - 15)
                       end
                      pause(.25)
                      %brick.StopMotor('AD','Coast')
                   end
               end

               if color == 5 %5 = red color detected 
                       brick.StopMotor('AD','Coast');
                       pause(4); %%change to 4 seconds for final run
                       brick.MoveMotor('A', -amotor)
                       brick.MoveMotor('D', -dmotor)
                       pause(.5);
               end
               if color == 2 || color == 3  %2/3/4 manual control
                   brick.StopMotor('AD', 'Coast')
                   manualMode = true;
                   disp("Exiting Automatic mode")
                   break;
                   %allow user to maneuver and pick up the target
               end
            end
       end
       
       if key == 'q'
           break
       end
       if key == 'm' || manualMode == true %manual control
           disp("Entering Manual Mode");
           while 1
               switch key
                   case 'w' %w go forward
                        brick.MoveMotor('A', -amotor/2)
                        brick.MoveMotor('D', -dmotor/2)
                   case 's' %s go backward
                       brick.MoveMotor('A', amotor/2)
                       brick.MoveMotor('D', dmotor/2)

                   case 'p' %p stops the vehical and exits the loop
                       brick.StopMotor('AD', 'Coast')
                       manualMode = false;
                       disp("Exiting Manual Mode")
                       break %exits manual mode

                   case 'a' %a is turn left
                       brick.MoveMotor('A', amotor/2)
                       brick.MoveMotor('D',-dmotor/2)

                   case 'd' %d is turn right
                       brick.MoveMotor('A', -amotor/2)
                       brick.MoveMotor('D', dmotor/2)

                   case 'h' %h to honk horn
                   brick.playTone(100,420,500)

                   case'q' %q to forward and turn left
                           brick.MoveMotor('A',-amotor/4)
                           brick.MoveMotor('D',-dmotor/2)
                   

                   case 'e' %e to forward and turn right
           
                           brick.MoveMotor('A',-dmotor/2)
                           brick.MoveMotor('D',-amotor/4)

                   case 'z' %reverse right
                       brick.MoveMotor('A', amotor/4)
                       brick.MoveMotor('D', dmotor/2)

                   case 'c' %reverse left
                       brick.MoveMotor('A', amotor/2)
                       brick.MoveMotor('D', dmotor/4)
                   
                   case 'f' %rotate motor up
                       brick.MoveMotorAngleRel('B', 1, 5, 'Coast');
                   case 'g' %rotate motor down
                       brick.MoveMotorAngleRel('B',-1, 5, 'Coast');
                   case 'u' %passenger dropped off
                       droppedOff = 1;
               end
               
               pause(.25) %before executing next loop, pause and then brake
               brick.StopMotor('AD','Coast')
               
           end
       end

       %gets battery and warns if we are running low on battery
       v = brick.GetBattLevel();
       %disp(v);
       if v < 10 && v > 5 && j == 0
           disp(v);
           brick.playTone(100,800,250)
           j = 1; %indicates that we have made the warning sound so this doesnt repeat
       elseif v < 5
           disp(v);
           brick.playTone(100, 800, 1000)
           brick.StopMotor('AD', 'Coast')
       end
       
       pause(.25) %before executing next loop, pause and then brake
       brick.StopMotor('AD','Coast')
end
