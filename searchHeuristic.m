function T = searchHeuristic (Number_Sensor_Nodes, Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, BS, Sensor_Node_Energy, Sensor_Nodes, Min_Energy, Lm, p, Inverse_Cost, Cluster_Radius, Distance)
S = 0.1;         % Initial Step Size
s = S ;          % Current step size %
%k = 0 ;         % Current number of iterations %
kmax = 50 ;       % Maximum number of iterations %
to = 0.5 ;         % Initial value of the lagrangian surrogate multiplier %
t = to ;         % Current value of the Lagrangian Surrogate Multiplier%
T = t ;          % Final Value of the Lagrangian Surrogate Multiplier %
z = 0 ;          % Maximum value of the Relaxed Objective Function %
tplusdef = -1 ;  % Undefined 
tminusdef = -1;  % Undefined 
zplus = 0;
zminus = 0;
tval = zeros (kmax, 3);
%min_Lm
for k = 1 : kmax    
    [Y,value] =  solve_P_Median_Relaxed (Number_Sensor_Nodes, Sensor_Node_Energy, Min_Energy, Lm, p, t, Inverse_Cost, Cluster_Radius, Distance);    
    tval (k, 1) = t;
    tval (k, 2) = value;
   % t = t + s;
    if(value > z)
        T = t;
        z = value;
        mu_lambda = 0;
        for i  = 1 : Number_Sensor_Nodes
              s1 = sum(Y(i,:));
              s2 = 1 - s1;
              mu_lambda = mu_lambda + Lm(i) * s2;    %mu_lambda is the slope of lagrange surrogate 
        end          
         if(mu_lambda < 0)
             tval (k, 3) = -1;
             tminus = t; %if slope is decreasing the current t,z = start range%
             tminusdef = 1;
             zminus = z;
             if((tplusdef == -1))
                 t = t + s;             
                 %tplusdef = 1;
             else
                 t = (zplus * tplus + zminus * tminus )/(zplus + zminus);
                  [Y,value]  =  solve_P_Median_Relaxed (Number_Sensor_Nodes, Sensor_Node_Energy, Min_Energy, Lm, p, t, Inverse_Cost, Cluster_Radius, Distance);
                 if(value > z)
                     T = t;
                     z= value;
                 end
                     break;
             end
         else
             tval (k, 3) = 1;
             tplus = t;
             tplusdef = 1;
             zplus = z;
             if((tminusdef == -1))
                 t = t - s;
                % tminusdef = 1;
             else
                   t = (zplus * tplus + zminus * tminus )/(zplus + zminus);
                    [Y,value] =  solve_P_Median_Relaxed (Number_Sensor_Nodes, Sensor_Node_Energy, Min_Energy, Lm, p, t, Inverse_Cost, Cluster_Radius, Distance);
                     if(value > z)
                         T = t;
                         z= value;
                     end
                     break;
             end
         
         end
    else
           t=t-s/2;
           [Y,value]  =  solve_P_Median_Relaxed (Number_Sensor_Nodes, Sensor_Node_Energy, Min_Energy, Lm, p, t, Inverse_Cost, Cluster_Radius, Distance);           
           
           
           if(value > z)
                         T = t;
                         z = value;                            
           else
               s = s/2;
           end
           
    end 
  
end
%plot (tval(:,1), tval(:,2));
%tval
end
%here tplus and tminus gives us the range of Lagrange Surrogate Multiplier%
