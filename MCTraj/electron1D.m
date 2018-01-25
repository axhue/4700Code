function [] = electron1D(force)
    e_x = 0;
    e_v = 0;
    
    e_mass = 9.109e-31;
    acceleration = force/e_mass;
    plot(e_x,e_v);
    figure(1);
    sum = 0
    hold on;
    for t = 1:10000
       sum = sum + e_v;
       drift_v = sum/t;
       dtime = 1;
       e_v = e_v + acceleration*dtime;
       
       delta_d = e_v * dtime;
       
       e_x = e_x + delta_d;
       
       rand_var = rand;
       
       if (rand_var < 0.05)
           e_v = 0;
       end
       
       %ax1 = subplot(2,1,1);
       hold on
       subplot(2,1,1),plot(t,e_v,'.b');
       xlabel("time");
       ylabel("velocity")
       title(["Drift velocity: " num2str(drift_v)]);
       hold on
       subplot(2,1,2),plot(t,e_x,'.r');
      
       xlabel("time");
       ylabel("distance")
       hold on
       %plot(e_x,e_v,'.g');
       pause(0.1);
    end
    % F = ma
    
    