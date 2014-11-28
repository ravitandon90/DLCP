% Calculate the inverse cost 
function Inverse_Cost = getInverseCost (Packet_Size, Packet_Transmission_Cost, Amplification_Energy_Multi_Path, Amplification_Energy_Free_Space, Energy_Data_Aggregation, BS, Sensor_Node_Energy, i, j, Sensor_Nodes, Threshold_Distance, Distance)
Distance_BS = getDistance(Sensor_Nodes(j, 1), Sensor_Nodes (j, 2), BS(1, 1), BS(1, 2));
if (Distance_BS > Threshold_Distance)
    Energy_Spent_CH = Packet_Size * (Packet_Transmission_Cost + Energy_Data_Aggregation) + Packet_Size *  Amplification_Energy_Multi_Path * Distance_BS ^4;
else
    Energy_Spent_CH = Packet_Size * (Packet_Transmission_Cost + Energy_Data_Aggregation) + Packet_Size *  Amplification_Energy_Free_Space * Distance_BS ^2;
end       
    Residual_Energy_CH = Sensor_Node_Energy(j) - Energy_Spent_CH;
    Energy_Spent_SN = Packet_Size * (Packet_Transmission_Cost) +  Packet_Size *  Amplification_Energy_Free_Space * Distance(i, j) ^2;
    Residual_Energy_SN = Sensor_Node_Energy(i) - Energy_Spent_SN;
    Inverse_Cost = 1/ ((Residual_Energy_CH));
end
