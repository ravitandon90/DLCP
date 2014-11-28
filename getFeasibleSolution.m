function [Y_Feasible, value_Feasible] = getFeasibleSolution (Number_Sensor_Nodes, Sensor_Node_Energy, Min_Energy, Distance, Cluster_Radius, Inverse_Cost, Y, Neighbor, Neighbor_Count, Packet_Transmission_Cost, Energy_Data_Aggregation, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Packet_Size, BS, Sensor_Nodes, Threshold_Distance)
Y_Feasible = zeros (Number_Sensor_Nodes, Number_Sensor_Nodes);

done = zeros (Number_Sensor_Nodes, 1);

% Get a feasible solution 
    for i = 1 : Number_Sensor_Nodes
        if (Y (i, i) == 1)
            if (Sensor_Node_Energy (i) > Min_Energy)
                Y_Feasible (i, i) = 1;
                done (i) = 1;
            end
        end
    end

value_Feasible = 0;
    for i = 1 : Number_Sensor_Nodes
        Min_Cost = inf;
        Min_Cost_Index = i;
        if (Y_Feasible (i, i) == 1)
            continue;
        end
        if (Sensor_Node_Energy (i) > Min_Energy)
            for j = 1 : Number_Sensor_Nodes                                
                if ((i ~= j) && (Sensor_Node_Energy (j) > Min_Energy) && (Y(j, j) == 1) && (Distance (i, j) <= Cluster_Radius))
                    invCost = Inverse_Cost (i, j);
                    if (invCost < Min_Cost)
                        Min_Cost_Index = j;
                        Min_Cost = invCost;
                    end
                end
            end
        end        
        if (i ~= Min_Cost_Index)
            value_Feasible = value_Feasible + Inverse_Cost (i, Min_Cost_Index);
            Y_Feasible (i, Min_Cost_Index) = 1;
            done (i) = 1;
        end       
    end


% We calculate the cost of becoming a cluster head based on the residual
% energy of the sensor nodes
Cost_CH = zeros (Number_Sensor_Nodes, 2);
% We have a matrix of Neighbor_Count
for i = 1 : Number_Sensor_Nodes     
        DtoBS = getDistance (Sensor_Nodes(i, 1), Sensor_Nodes(i, 2), BS(1, 1), BS(1, 2));        
        if (DtoBS > Threshold_Distance)
            CostToBS = Packet_Size * Amplification_Energy_Multi_Path *(DtoBS)^4;
        else
            CostToBS = Packet_Size * Amplification_Energy_Free_Space *(DtoBS)^2;
        end        
    energy_Required = Packet_Size * (Packet_Transmission_Cost + Energy_Data_Aggregation) * Neighbor_Count (i) + CostToBS;  
    Cost_CH (i, 1) = 1/(Sensor_Node_Energy (i) - energy_Required);    
    Cost_CH (i, 2) = i;
end

Cost_CH_Sorted = sortrows (Cost_CH, 1);

for i = 1 : Number_Sensor_Nodes
    index = Cost_CH_Sorted (i, 2); 
    if (Sensor_Node_Energy (index) > Min_Energy)
    if (done (index) == 0)
        done (index) = 1;
        Y_Feasible (index, index) = 1;
        for j = 1 : Neighbor_Count (index)
            node_Index = Neighbor (index, j);
            if ((Sensor_Node_Energy (node_Index) > Min_Energy)  && ((done (node_Index) == 0)))
            Y_Feasible (node_Index, index) = 1;
            value_Feasible = value_Feasible + Inverse_Cost (node_Index, index);
            done (node_Index) = 1;
            end
        end
    end
    end
end

end