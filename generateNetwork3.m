% File to generate the wireless sensor network in a circular manner
Number_Sensors = 100;

Number_High_Energy_Nodes = Number_Sensors * Percent_High_Energy_Nodes/100;
Number_Low_Energy_Nodes = Number_Sensors * (1-(Percent_High_Energy_Nodes/100));
Center = ones (1, 2) * 1200;
Area_Net = 100;
Percent_High_Energy_Nodes = 5;
Percent_High_Energy_Nodes_Step = 5;

for j = 1 : 20  
Radius_Net = Area_Net/(sqrt(pi));
position = zeros (Number_Sensors, 2);
num = rand (Number_Low_Energy_Nodes, 2);
for i = 1 : Number_Low_Energy_Nodes
    radius = num(i, 1)* Radius_Net;
    theta = num(i, 2)*2*pi;
    position (i, 1) = Center (1, 1) + radius * cos (theta);
    position (i, 2) = Center (1, 2) + radius * sin (theta);
end
num = rand (Number_High_Energy_Nodes, 2);
Radius_Net = 100/(sqrt(pi));
for i = 1 : Number_High_Energy_Nodes
    radius = num(i, 1)* Radius_Net;
    theta = num(i, 2)*2*pi;
    position (Number_Low_Energy_Nodes+i, 1) = Center (1, 1) + radius * cos (theta);
    position (Number_Low_Energy_Nodes+i, 2) = Center (1, 2) + radius * sin (theta);
end
filePath = '..\Sensor_Network\Sensor_Network_100_100_';
fileName = strcat (filePath, int2str(Percent_High_Energy_Nodes), '.txt');
writeToFile (fileName, position);
Percent_High_Energy_Nodes = Percent_High_Energy_Nodes + Percent_High_Energy_Nodes_Step;
end