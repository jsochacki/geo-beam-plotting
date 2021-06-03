function plot_geobeamsglobe(ax, points, alts)

N = size(points, 3);
L = size(points, 1);
extensionvector = ones(L, 1);
hold(ax, 'on')
for index = 1:1:N
   mygeoplot3(ax, points(:,1,index), points(:,2,index), alts(index) .* extensionvector, 'b')
end

end