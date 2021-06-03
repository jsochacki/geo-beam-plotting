function plot_geobeamsmap(ax, points)

N = size(points, 3);
hold(ax,'on');
for index = 1:1:N
   geoplot(ax, points(:,1,index), points(:,2,index), 'b')
end

end