function indexOfClusterHead = calculateNewClusterHead (Number_Sensor_Nodes, Y_Old, oldCH, Energy_Sensor_Node, Min_Energy, Distance, Cluster_Radius, Inverse_Cost)
Cost = zeros (Number_Sensor_Nodes, 1);
Min_Cost = inf;
Min_Cost_Index = oldCH;
for  i = 1 : Number_Sensor_Nodes
    if (Y_Old (i, oldCH) == 1)
        if (Energy_Sensor_Node (i) > Min_Energy)
            for j = 1 : Number_Sensor_Nodes
                if ((i ~= j) && (Energy_Sensor_Node (j) > Min_Energy) && (Distance (i, j) < Cluster_Radius) && (Y_Old(j, oldCH) == 1))
                Cost (i) = Cost (i) +  Inverse_Cost (j, i);
                end
            end
        end    
    if(Cost (i) < Min_Cost)
        Min_Cost = Cost (i);
        Min_Cost_Index = i;
    end
    end
end
indexOfClusterHead = Min_Cost_Index;
end
