% This the main file that starts each code
Packet_Size = 4000; % packet size 500 Bytes => 4000 bits.
Packet_Transmission_Cost = 50 * (10 ^ -9); % Packet Transmission Cost = 50 nano Joule per Bit per Packet
Amplification_Energy_Multi_Path = 13 * (10 ^ -16);   % Packet Amplification Cost = 0.0013 pico Joule per Bit per metre squared
Amplification_Energy_Free_Space = 10  * (10 ^ (-12)); % 
Energy_Data_Aggregation = 5 * (10 ^ -9);
Num_Sensors = 100;
Area_Net = 100 * 100;
Radius_Net = sqrt(Area_Net/pi);
BS = [100, 100];
Threshold_Distance = 87;
Cluster_Radius_Init = 25;
Cluster_Radius_Step = 0;
current_Cluster_Radius = Cluster_Radius_Init;
% Sensor_Nodes = readFromFile('..\Sensor_Network\Sensor_Network.txt');
Percent_High_Energy_Nodes = 10;
Number_High_Energy_Nodes = Num_Sensors * Percent_High_Energy_Nodes/100;
Number_Low_Energy_Nodes = Num_Sensors * (1-(Percent_High_Energy_Nodes/100));
% Sensor_Nodes = zeros (Num_Sensors, 2);
numFrames = 5;
Initial_Energy = 0.5;
Min_Energy = 0.01;

maxCount = 10;
Iteration_Max = 5;



for Iteration = 1: Iteration_Max
    current_Cluster_Radius = Cluster_Radius_Init;
    Neighbors = zeros (Num_Sensors, Num_Sensors);
    Distance =  zeros (Num_Sensors, Num_Sensors);
    count = 0;
    Sensor_Nodes = zeros (Num_Sensors, 2);
    
    for count = 1 : maxCount
        Ratio_High_Low_Energy = count;
        Sensor_Node_Energy = ones (Num_Sensors, 1) * Initial_Energy;
        for j = 1 : Number_High_Energy_Nodes
            Sensor_Node_Energy (Number_Low_Energy_Nodes+j) = Initial_Energy * Ratio_High_Low_Energy;
        end

        
        num = rand (Number_Low_Energy_Nodes, 2);
        for i = 1 : Number_Low_Energy_Nodes
            radius = num(i, 1)* Radius_Net;
            theta = num(i, 2)*2*pi;
            Sensor_Nodes (i, 1) = BS (1, 1) + radius * cos (theta);
            Sensor_Nodes (i, 2) = BS (1, 2) + radius * sin (theta);
        end
        num = rand (Number_High_Energy_Nodes, 2);
        for i = 1 : Number_High_Energy_Nodes
            radius = num(i, 1)* Radius_Net;
            theta = num(i, 2)*2*pi;
            Sensor_Nodes (i+Number_Low_Energy_Nodes, 1) = BS (1, 1) + radius * cos (theta);
            Sensor_Nodes (i+Number_Low_Energy_Nodes, 2) = BS (1, 2) + radius * sin (theta);
        end
        % Calculating distance between the sensor nodes
        Neighbor_Count = zeros (Num_Sensors, 1);
        for i=1 : Num_Sensors        
            for j=1 : Num_Sensors            
                Distance(i,j) = getDistance(Sensor_Nodes(i,1), Sensor_Nodes(i,2), Sensor_Nodes(j,1), Sensor_Nodes(j,2));
                if (Distance (i, j) <= current_Cluster_Radius)
                    Neighbor_Count (i) = Neighbor_Count (i) + 1;
                    Neighbors (i, Neighbor_Count (i)) = j;
                end
            end
        end
    
    run_ALCP_H (Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, Num_Sensors, BS, Threshold_Distance, Sensor_Nodes, Distance, Sensor_Node_Energy, current_Cluster_Radius, count, Min_Energy, numFrames, Iteration);
%     current_Cluster_Radius = current_Cluster_Radius + Cluster_Radius_Step;
    end
end


