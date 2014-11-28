% Main file - for LCP Heterogeneous - define parameters here
function [frac_sum_avg, aveCHE_ratio] = run_ALCP_H (Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, Num_Sensors, BS, Threshold_Distance, Sensor_Nodes, Distance, Sensor_Node_Energy, Cluster_Radius, count, Min_Energy, numFrames, Iteration)
Number_Low_Energy_Nodes=90;
p = 0.10*Num_Sensors;
path = 'C:/Users/RaviHome/Desktop/Results_Heterogeneous/PerIteration/DLCP/dataPerRound_ALCP_';
fileName = strcat (path, int2str(count), '_', int2str(Iteration), '.txt');
collectedDataPerRound = fopen (fileName, 'w');

Inverse_Cost = zeros (Num_Sensors, Num_Sensors);
Min_Cost = inf;

for i=1 : Num_Sensors        
    for j=1 : Num_Sensors  
        if (i == j)
            continue;
        else
            if (Distance (i, j) > Cluster_Radius)
                continue;
            else
                Inverse_Cost (i, j) = getInverseCost (Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, BS, Sensor_Node_Energy, i, j, Sensor_Nodes, Threshold_Distance, Distance);
            end
            if (Inverse_Cost (i, j) < Min_Cost)
                Min_Cost = Inverse_Cost (i, j);
            end            
        end
    end
end

LM_Init = Min_Cost;
Lm = ones (Num_Sensors, 1) * LM_Init;


eff_num_it = 0;
total_Energy_Used = 0;
total_Messages_Transmitted = 0;

T = searchHeuristic (Num_Sensors, Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, BS, Sensor_Node_Energy, Sensor_Nodes, Min_Energy, Lm, p, Inverse_Cost, Cluster_Radius, Distance);
Inverse_Cost = getInverseCostMatrix (Num_Sensors, Distance, Cluster_Radius, Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, BS, Sensor_Node_Energy, Sensor_Nodes, Threshold_Distance);

frac_sum=0;
aveClusterHeadEnergySum=0;
while (1)
[Neighbors, Neighbor_Count] = getNeighbors (Num_Sensors, Sensor_Nodes, Distance, Sensor_Node_Energy, Min_Energy,  Cluster_Radius);
if (eff_num_it == 0)
    % The Centralized Phase
    Y = solve_P_Median_SubG (Num_Sensors, Sensor_Node_Energy, Min_Energy, Lm, p, T, Cluster_Radius, Distance, Inverse_Cost, Neighbors, Neighbor_Count, Packet_Transmission_Cost, Energy_Data_Aggregation, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Packet_Size, BS, Sensor_Nodes, Threshold_Distance);
else
    % The Distributed Phase
    Y = solve_P_Median_Homogeneous (Num_Sensors, Y, Min_Energy, Sensor_Node_Energy, Distance, Cluster_Radius, Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, BS, Sensor_Node_Energy, Sensor_Nodes, Threshold_Distance, Inverse_Cost, Neighbors, Neighbor_Count);
end
[stdDev, maxClusterSize, aveClusterHeadEnergy] = clusterEval (Y, Sensor_Node_Energy, Min_Energy, Num_Sensors);

% Updating the energy within the sensor nodes 
[Sensor_Node_Energy, EnergyUsedThisRound, numMessagesTransmittedThisRound] = updateEnergies (Num_Sensors, Y, Sensor_Nodes, BS, Threshold_Distance, Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Free_Space, Amplification_Energy_Multi_Path, Energy_Data_Aggregation, Sensor_Node_Energy, Distance, Cluster_Radius, numFrames, Min_Energy);


total_Messages_Transmitted = total_Messages_Transmitted + numMessagesTransmittedThisRound;
Inverse_Cost = getInverseCostMatrix (Num_Sensors, Distance, Cluster_Radius, Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, BS, Sensor_Node_Energy, Sensor_Nodes, Threshold_Distance);
NumberDead = getNumberOfNodesDead (Sensor_Node_Energy, Min_Energy, Num_Sensors);

% Calculating Rounds
eff_num_it = eff_num_it + 1;

% Calculating Nodes Alive
nodesAlive = Num_Sensors - NumberDead; 
% Calculating NumberOfMessages Transmitted

% Calculating Number of cluster heads
[numClusterHead, frac] = calculateNumberOfClusterHeads (Num_Sensors, Sensor_Node_Energy, Min_Energy, Y, Number_Low_Energy_Nodes);
frac_sum = frac_sum + frac;
% Calculating Average Energy 
averageEnergy = mean (Sensor_Node_Energy);

% Calculating Std Dev Energy 
stdDevEnergy = std (Sensor_Node_Energy);

% Calculating Total Energy Used
total_Energy_Used = total_Energy_Used + EnergyUsedThisRound;

% Calculating Energy Remaining of Nodes Alive
Energy_Nodes_Alive = getEnergyNodesAliveMatrix (nodesAlive, Sensor_Node_Energy, Num_Sensors, Min_Energy);
stdDevEnergy_alive = std (Energy_Nodes_Alive);
averageEnergy_alive = mean (Energy_Nodes_Alive);
if (~isnan(aveClusterHeadEnergy/averageEnergy_alive))
aveClusterHeadEnergySum = aveClusterHeadEnergySum + aveClusterHeadEnergy/averageEnergy_alive;
end
fprintf(collectedDataPerRound, '%d\t%d\t%f\t%f\t%d\t%f\t%f\t%f\t%f\t%f\t%d\t%f\t%f\t%f\t%f\t%f\t%f\r\n',  eff_num_it, nodesAlive, NumberDead/Num_Sensors, total_Messages_Transmitted/10000, numClusterHead, averageEnergy, stdDevEnergy, total_Energy_Used, EnergyUsedThisRound, stdDev, maxClusterSize, aveClusterHeadEnergy, averageEnergy_alive, numMessagesTransmittedThisRound/10000, stdDevEnergy_alive, frac, aveClusterHeadEnergy/averageEnergy_alive);

if (NumberDead >= 0.95*(Num_Sensors))
    break;
end

end
fclose (collectedDataPerRound);
frac_sum_avg = frac_sum/eff_num_it;
aveCHE_ratio = aveClusterHeadEnergySum/eff_num_it;
end