function Y_Feasible = solve_P_Median_Homogeneous (Number_Sensor_Nodes, Y_Old, Min_Energy, Energy_Sensor_Node, Distance, Cluster_Radius, Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, BS, Sensor_Node_Energy, Sensor_Nodes, Threshold_Distance, Inverse_Cost, Neighbor, Neighbor_Count)
Y_New = zeros (Number_Sensor_Nodes, Number_Sensor_Nodes);
CH_Elected = zeros (Number_Sensor_Nodes, 1);
clusterhead_Count = 0;

for i = 1 : Number_Sensor_Nodes 
if (Y_Old(i, i) == 1)
    if (Energy_Sensor_Node (i) <= Min_Energy)
        continue;
    else
        if (checkIfAllDead (Y_Old, i, Energy_Sensor_Node, Min_Energy, Number_Sensor_Nodes) ==  1)
            %clusterhead_Count =  clusterhead_Count + 1;
            %CH_Elected (clusterhead_Count) = i;            
        else
            indexOfClusterHead = calculateNewClusterHead (Number_Sensor_Nodes, Y_Old, i, Energy_Sensor_Node, Min_Energy, Distance, Cluster_Radius, Inverse_Cost);
            clusterhead_Count =  clusterhead_Count + 1;
            CH_Elected (clusterhead_Count) = indexOfClusterHead;            
        end    
    end    
end
end

for i = 1: clusterhead_Count
    
    indexClusterHead = CH_Elected (i);
    Y_New (indexClusterHead, indexClusterHead) = 1;    
end

%Inverse_Cost =  getInverseCostMatrix (Number_Sensor_Nodes, Distance, Cluster_Radius, Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, BS, Sensor_Node_Energy, Sensor_Nodes, Threshold_Distance);
[Y_Feasible, value_New] = getFeasibleSolution (Number_Sensor_Nodes, Sensor_Node_Energy, Min_Energy, Distance, Cluster_Radius, Inverse_Cost, Y_New, Neighbor, Neighbor_Count, Packet_Transmission_Cost, Energy_Data_Aggregation, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Packet_Size, BS, Sensor_Nodes, Threshold_Distance);

end