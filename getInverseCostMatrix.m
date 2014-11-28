function Inverse_Cost = getInverseCostMatrix (Number_Sensor_Nodes, Distance, Cluster_Radius, Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, BS, Sensor_Node_Energy, Sensor_Nodes, Threshold_Distance)
Inverse_Cost = zeros (Number_Sensor_Nodes, Number_Sensor_Nodes);
for i=1 : Number_Sensor_Nodes        
    for j=1 : Number_Sensor_Nodes  
        if (i == j)
            continue;
        else
            if (Distance (i, j) > Cluster_Radius)
                continue;
            else
                Inverse_Cost (i, j) = getInverseCost (Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, BS, Sensor_Node_Energy, i, j, Sensor_Nodes, Threshold_Distance, Distance);
            end
        end
    end
end
end