clear; clc;
% clf
close all
%%
with_feedback = true;
with_controler = true;
%%
t_end = 4;
%% 
s = tf('s');

T = [.3 .3];
kp = 1;
G = (kp) / ((T(1)*s+1)*(T(2)*s+1))

% G = feedback(G, 1);

[y_op, t] = step(G, t_end);
u = ones(size(t));
hold on
title_ = {['\tau : [', num2str(T), '], Gain: ', num2str(kp)]};

plot(t, u, 'k--', 'displayName', 'ref')
plot(t, y_op, 'displayName', 'open loop')

if with_feedback
    H = feedback(G, 1);
    [y_cl, t] = step(H, t_end);
    plot(t, y_cl, 'displayName', 'closed loop')
end

if with_controler
    opt = pidtuneOptions('DesignFocus', 'disturbance-rejection');
    [C, info ]= pidtune(G, 'pid')
        C.Kp;
        Ti = C.Kp / C.Ki;
        Td = C.Kd / C.Kp;
    H = feedback(G*C, 1);

    [yc, t] = step(H, t_end);
    plot(t, yc, 'g', 'displayName', 'with PID controler')
    title_ = {title_{:}, ['PID: K_p: ', num2str(C.Kp), ', T_i: ', num2str(Ti), ', T_d: ', num2str(Td)]};
end
title(title_);
legend('show')
grid on