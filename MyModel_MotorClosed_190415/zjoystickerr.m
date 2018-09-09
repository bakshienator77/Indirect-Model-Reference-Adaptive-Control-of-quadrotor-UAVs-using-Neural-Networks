%z joystick error
% INPUT: joystick in
% OUTPUT: rounded to zero

function out=zjoystickerr(in)
joystickin=in(1);
if abs(joystickin)<=0.005
    joystickout=0;
else
    joystickout=joystickin;
end
out(1)=joystickout;