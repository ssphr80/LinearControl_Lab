clear; clc; clf
%%
with_feedback = true;
with_controler = true;
%%
t_end = 3.5;
s = tf('s');
taw=0.1 ; zita=0.2;

G = (1) / (taw*s*(taw*s+2*zita));
G = feedback(G, 1);

[y_op, t] = step(G, t_end);
u = ones(size(t));
hold on
title_ = {['\tau : ', num2str(taw), ' ,  \xi: ', num2str(zita)]};
plot(t, u, 'k--', 'displayName', 'ref')
plot(t, y_op, 'displayName', 'open loop')

if with_feedback
    H = feedback(G, 1);
    [y_cl, t] = step(H, t_end);
    plot(t, y_cl, 'displayName', 'closed loop')
end

if with_controler
    opt = pidtuneOptions('DesignFocus', 'disturbance-rejection');
    [C, info ] = pidtune(G, 'pid')
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