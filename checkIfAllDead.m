function allDead = checkIfAllDead (Y, chIndex, Energy_Sensor_Node, Min_Energy, Number_Sensor_Nodes)
allDead = 1;
for i = 1 : Number_Sensor_Nodes
    if ((Y(i, chIndex) == 1) && (i ~= chIndex))
        if (Energy_Sensor_Node (i) > Min_Energy)
            allDead = 0;
            break;
        end
    end
end
end