dotroll_c=dotroll.Data(1:end-1);
dotpitch_c=dotpitch.Data(1:end-1);
dotyaw_c=dotyaw.Data(1:end-1);
dotz_c=dotz.Data(1:end-1);
dotx_c=dotx.Data(1:end-1);
doty_c=doty.Data(1:end-1);
rollacc_c=rollacc.Data(1:end-1);
pitchacc_c=pitchacc.Data(1:end-1);
yawacc_c=yawacc.Data(1:end-1);
zacc_c=z_acc.Data(1:end-1);
xacc_c=x_acc.Data(1:end-1);
yacc_c=y_acc.Data(1:end-1);
z_c=z.Data(1:end-1);
x_c=x.Data(1:end-1);
y_c=y.Data(1:end-1);
roll_c=roll.Data(1:end-1);
pitch_c=pitch.Data(1:end-1);
yaw_c=yaw.Data(1:end-1);

X_zrpyset2=[rollcontrol.Data pitchcontrol.Data yawcontrol.Data zcontrol.Data ...
    [0 0 0 -45 0 0 0 0 0 0 0 0 0 0 0 9.8 0 0; roll_c pitch_c yaw_c z_c x_c y_c ...
    dotroll_c dotpitch_c dotyaw_c dotz_c dotx_c doty_c ...
    rollacc_c pitchacc_c yawacc_c zacc_c xacc_c yacc_c]];

y_zrpyset2=[roll.Data pitch.Data yaw.Data z.Data x.Data y.Data ...
    dotroll.Data dotpitch.Data dotyaw.Data dotz.Data dotx.Data doty.Data ...
    rollacc.Data pitchacc.Data yawacc.Data z_acc.Data x_acc.Data y_acc.Data];

