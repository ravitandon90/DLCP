function Y_Feasible = solve_P_Median_SubG (Number_Sensor_Nodes, Sensor_Node_Energy, Min_Energy, Lm, p, t, Cluster_Radius, Distance, Inverse_Cost, Neighbor, Neighbor_Count, Packet_Transmission_Cost, Energy_Data_Aggregation, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Packet_Size, BS, Sensor_Nodes, Threshold_Distance)

lb = -inf;
ub = +inf;

Pi = 2;
iter_Since_Update_Lb =0 ;
while (1)
    
[Y, value] = solve_P_Median_Relaxed (Number_Sensor_Nodes, Sensor_Node_Energy, Min_Energy, Lm, p, t, Inverse_Cost, Cluster_Radius, Distance);   
[Y_Feasible, value_Feasible] = getFeasibleSolution (Number_Sensor_Nodes, Sensor_Node_Energy, Min_Energy, Distance, Cluster_Radius, Inverse_Cost, Y, Neighbor, Neighbor_Count, Packet_Transmission_Cost, Energy_Data_Aggregation, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Packet_Size, BS, Sensor_Nodes, Threshold_Distance);

% Updating the value of lb
if (value > lb)
    iter_Since_Update_Lb = 0;
else
    iter_Since_Update_Lb = iter_Since_Update_Lb + 1;
    if (iter_Since_Update_Lb == 30)
        Pi = Pi / 2;
        iter_Since_Update_Lb =0;
    end   
end

lb = max (lb, value);

% Updating the value of ub
ub = min (ub, value_Feasible);

g = zeros (Number_Sensor_Nodes, 1);
for i = 1 : Number_Sensor_Nodes 
    v = 0;
    for j = 1 : Number_Sensor_Nodes
        v = v + Y(i, j); 
    end
    g (i) = 1 - v;
end

%Update the step size
Step_Size = (Pi * (ub - lb)) / (norm (g) ^ 2);

%Updating the Lagrange Multiplier
for i = 1 : Number_Sensor_Nodes 
    Lm (i) = Lm (i) + Step_Size * g (i);
end
if (stoppingCondition (Pi, ub, lb, norm(g)) == 1)
    break;
end
end
    
end
